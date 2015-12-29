#!/bin/bash

function print_usage (){
    echo "Usage: provision.sh --target=provider --master=MASTER --slave=SLAVE"
    echo "provider        aws|do|azure|vagrant"
    echo "MASTER          number of master nodes"
    echo "SLAVE           number of slave nodes"
}

function provision_digital_ocean() {
    source do.source

    for (( i=1; i <= $1; i++ )) do
        echo "Provisioning master $i"
        ansible-playbook -i digital_ocean.py provision/do-master.yaml -e master_id=$i -e ssh_key=\""$SSH_KEY_ID"\" -e size=$SIZE -e location=$LOCATION -e image=$IMAGE_NAME
    done

    for (( i=1; i <= $2; i++ ))  do
        echo "Provisioning slave $i" 
        ansible-playbook -i digital_ocean.py provision/do-slave.yaml -e slave_id=$i -e ssh_key=\""$SSH_KEY_ID"\" -e size=$SIZE -e location=$LOCATION -e image=$IMAGE_NAME
    done

    ansible-playbook -i digital_ocean.py provision/do-docker-registry.yaml -e ssh_key=\""$SSH_KEY_ID"\" -e size=$SIZE -e location=$LOCATION -e image=$IMAGE_NAME

    sed -i.bak "s|__inv_file|digital_ocean.py|g;s|__adds|-vvv --private-key $SSH_KEY_FILE|g;s|__iface|eth1|g;s|__username|root|g" bootstrap-*.sh
    sed -i.bak "s|__inv_file|digital_ocean.py|g;s|__adds|-vvv --private-key $SSH_KEY_FILE|g;s|__iface|eth1|g;s|__username|root|g" docker-build.sh
    sed -i.bak "s|__inv_file|digital_ocean.py|g;s|__adds|-vvv --private-key $SSH_KEY_FILE|g;s|__iface|eth1|g;s|__username|root|g" marathon-deploy.sh
}

function provision_ec2() {
    source ec2.source
    cp provision/ec2.ini.tmpl ./ec2.ini
    sed -i.bak 's/__aws_region/'${AWS_REGION}'/g' ec2.ini

    for ((i=1; i<=$1; i++)); do
        echo "Provisioning master $i"
        ansible-playbook -i ec2.py provision/ec2-master.yaml -e master_id=$i -e vpc_subnet_id=$AWS_VPC_SUBNET_ID -e region=$AWS_REGION -e master_instance=$AWS_MASTER_INSTANCE -e ami=$AWS_AMI -e key_name=$AWS_SSH_KEY_NAME
    done

    for ((i=1; i<=$2; i++)); do
        echo "Provisioning slave $i" 
        ansible-playbook -i ec2.py provision/ec2-slave.yaml -e slave_id=$i -e ami=$AWS_AMI -e vpc_subnet_id=$AWS_VPC_SUBNET_ID -e slave_instance=$AWS_SLAVE_INSTANCE -e region=$AWS_REGION -e key_name=$AWS_SSH_KEY_NAME
    done

    ansible-playbook -i ec2.py provision/ec2-docker-registry.yaml -e vpc_subnet_id=$AWS_VPC_SUBNET_ID -e ami=$AWS_AMI -e docker_instance=$AWS_DOCKER_INSTANCE -e region=$AWS_REGION -e key_name=$AWS_SSH_KEY_NAME    
    ./ec2.py --refresh-cache > /dev/null

    ansible-playbook -i ec2.py provision/ec2-hostnames.yaml -e user=$BOXUSERNAME --private-key $SSH_KEY_PATH

    ./ec2.py --refresh-cache > /dev/null

    sed -i.bak "s/__inv_file/ec2.py/g;s/__adds/-vvv --private-key $SSH_KEY_FILE/g;s/__iface/eth0/g;s/__username/$BOXUSERNAME/g" bootstrap-*.sh
    sed -i.bak "s/__inv_file/ec2.py/g;s/__adds/-vvv --private-key $SSH_KEY_FILE/g;s/__iface/eth0/g;s/__username/$BOXUSERNAME/g" docker-build.sh
    sed -i.bak "s/__inv_file/ec2.py/g;s/__adds/-vvv --private-key $SSH_KEY_FILE/g;s/__iface/eth0/g;s/__username/$BOXUSERNAME/g" marathon-deploy.sh
}

function provision_vagrant() {
    cp provision/Vagrantfile ./
    cp provision/playbook.yml ./
    sed -i.bak s/__masters_count/$1/g Vagrantfile
    sed -i.bak s/__slaves_count/$2/g Vagrantfile
    vagrant up
    sed -i.bak 's/__inv_file/.vagrant\/provisioners\/ansible\/inventory\/vagrant_ansible_inventory/g;s/__adds/-vvv/g;s/__iface/eth1/g;s/__username/vagrant/g' bootstrap-*.sh
    sed -i.bak 's/__inv_file/.vagrant\/provisioners\/ansible\/inventory\/vagrant_ansible_inventory/g;s/__adds/-vvv/g;s/__iface/eth1/g;s/__username/vagrant/g' docker-build.sh
    sed -i.bak 's/__inv_file/.vagrant\/provisioners\/ansible\/inventory\/vagrant_ansible_inventory/g;s/__adds/-vvv/g;s/__iface/eth1/g;s/__username/vagrant/g' marathon-deploy.sh  
}

function provision_azure() {
    source azure.source

    for ((i=1; i<=$1; i++)); do
        echo "Provisioning master $i"
        ansible-playbook -i windows_azure.py $VERBOSITY provision/wa-master.yaml -e location=\""$LOCATION"\" -e username=$BOXUSERNAME -e ports="$MASTER_PORTS" -e password=$PASSWD -e cluster=$CLUSTER -e storage=$STORAGE_NAME -e master_id=$i -e cert_path=$CER_FILE -e pem_file=$PEM_FILE
    done

    for ((i=1; i<=$2; i++)); do
        echo "Provisioning slave $i"
        ansible-playbook -i windows_azure.py $VERBOSITY provision/wa-slave.yaml -e location=\""$LOCATION"\" -e username=$BOXUSERNAME -e ports=$SLAVE_PORTS -e password=$PASSWD -e cluster=$CLUSTER -e storage=$STORAGE_NAME -e slave_id=$i  -e cert_path=$CER_FILE -e pem_file=$PEM_FILE

    done

    ansible-playbook -i windows_azure.py $VERBOSITY provision/wa-docker-registry.yaml -e location=\""$LOCATION"\" -e username=$BOXUSERNAME -e ports=$DOCKER_PORTS -e password=$PASSWD -e cluster=$CLUSTER -e storage=$STORAGE_NAME -e cert_path=$CER_FILE -e pem_file=$PEM_FILE

    ./windows_azure.py --refresh-cache > /dev/null

    sed -i.bak "s|__inv_file|windows_azure.py|g;s|__adds|$VERBOSITY --private-key $PEM_FILE|g;s|__iface|eth0|g;s|__username|$BOXUSERNAME|g" bootstrap-*.sh
    sed -i.bak "s|__inv_file|windows_azure.py|g;s|__adds|$VERBOSITY --private-key $PEM_FILE|g;s|__iface|eth0|g;s|__username|$BOXUSERNAME|g" docker-build.sh
    sed -i.bak "s|__inv_file|windows_azure.py|g;s|__adds|$VERBOSITY --private-key $PEM_FILE|g;s|__iface|eth0|g;s|__username|$BOXUSERNAME|g" marathon-deploy.sh
}

# TODO set SOFT_CLOUD_PROVIDER

if [ $# = 0 ]; then
    print_usage
    exit
fi

cd infrastructure

rm bootstrap-*.sh
rm docker-build.sh
rm marathon-deploy.sh

cp bootstrap/bootstrap*.sh ./
cp bootstrap/docker-build.sh ./
cp bootstrap/marathon-deploy.sh ./


while getopts ":-:" optchar
do
    case "${optchar}" in
         -)
             case "${OPTARG}" in
               target=*)
                   TARGET=${OPTARG#*=}
                   ;;
               master=*)
                   MASTER=${OPTARG#*=}
                   ;;
               slave=*)
                   SLAVE=${OPTARG#*=}
                   ;;
             esac
             ;;
       esac
done

echo "Ready to provision $MASTER master(s) and $SLAVE slave(s) to $TARGET"

if [ $((MASTER%2)) -eq 0 ]; then
   echo "Number of master nodes is odd, should be even number."
   print_usage
   exit
fi

case "$TARGET" in
    "do")
        provision_digital_ocean $MASTER $SLAVE
        ;;
    "aws")
	provision_ec2 $MASTER $SLAVE
	;;
    "vagrant")
        provision_vagrant $MASTER $SLAVE
        ;;
    "azure")
        provision_azure $MASTER $SLAVE
        ;;
    *)
        print_usage
        exit
esac

rm *.bak

wait

