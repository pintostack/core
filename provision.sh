#!/bin/bash

function print_usage (){
    echo "Usage: provision.sh --target=provider --master=MASTER --slave=SLAVE"
    echo "provider        aws|do|azure|vagrant"
    echo "MASTER          number of master nodes"
    echo "SLAVE           number of slave nodes"
}

function provision_digital_ocean() {
    source source.digital_ocean
    #__do_token
    #__do_image
    #__do_region
    #__do_size
    #__ssh_key_path

    #Vagrantfile
    sed -i.bak "s|__masters_count|${1}|g;s|__slaves_count|${2}|g;s|__do_token|${DO_TOKEN}|g;s|__do_image|${DO_IMAGE}|g;s|__do_region|${DO_REGION}|g;s|__do_size|${DO_SIZE}|g;s|__ssh_key_path|${SSH_KEY_FILE}|g;" Vagrantfile
    
    vagrant up --provider=digital_ocean

    #bootstrap-*.sh
    sed -i.bak "s|__inv_file|${INVENTORY_FILE}|g;s|__adds|-vvv --private-key $SSH_KEY_FILE|g;s|__iface|eth1|g;s|__username|root|g" bootstrap-*.sh
    #docker-build.sh
    sed -i.bak "s|__inv_file|${INVENTORY_FILE}|g;s|__adds|-vvv --private-key $SSH_KEY_FILE|g;s|__iface|eth1|g;s|__username|root|g" docker-build.sh
    #marathon-deploy.sh
    sed -i.bak "s|__inv_file|${INVENTORY_FILE}|g;s|__adds|-vvv --private-key $SSH_KEY_FILE|g;s|__iface|eth1|g;s|__username|root|g" marathon-deploy.sh
}

function provision_aws() {
    source source.aws
    #__ssh_key_path
    #__aws_key_id
    #__aws_access_key
    #__aws_keypair_name
    #__aws_ami
    #__aws_instance_type
    #__aws_region
    #__aws_security_groups
    #__aws_username

    #Vagrantfile
    sed -i.bak "s|__masters_count|$1|g;s|__slaves_count|$2|g;s|__aws_key_id|$AWS_KEY_ID|g;s|__aws_access_key|$AWS_ACCESS_KEY|g;s|__aws_keypair_name|$AWS_KEYPAIR_NAME|g;s|__aws_ami|$AWS_AMI|g;s|__aws_instance_type|$AWS_INSTANCE_TYPE|g;s|__aws_region|$AWS_REGION|g;s|'__aws_security_groups'|[$AWS_SECURITY_GROUPS]|g;s|__aws_username|${AWS_USERNAME}|g;s|__ssh_key_path|${SSH_KEY_FILE}|g;" Vagrantfile

    vagrant up --provider=aws

    ansible-playbook -i ${INVENTORY_FILE} provision/ec2-hostnames.yaml -e user=${AWS_USERNAME} --private-key $SSH_KEY_FILE

    #bootstrap-*.sh
    sed -i.bak "s|__inv_file|${INVENTORY_FILE}|g;s|__adds|-vvv --private-key $SSH_KEY_FILE|g;s|__iface|eth0|g;s|__username|${AWS_USERNAME}|g" bootstrap-*.sh
    #docker-build.sh
    sed -i.bak "s|__inv_file|${INVENTORY_FILE}|g;s|__adds|-vvv --private-key $SSH_KEY_FILE|g;s|__iface|eth0|g;s|__username|${AWS_USERNAME}|g" docker-build.sh
    #marathon-deploy.sh
    sed -i.bak "s|__inv_file|${INVENTORY_FILE}|g;s|__adds|-vvv --private-key $SSH_KEY_FILE|g;s|__iface|eth0|g;s|__username|${AWS_USERNAME}|g" marathon-deploy.sh
}

function provision_virtualbox() {
    source source.virtualbox
    #__ssh_key_path
    #__vbox_size

    sed -i.bak "s|__masters_count|${1}|g;s|__slaves_count|${2}|g;s|__vbox_size|${VBOX_SIZE}|g;s|__ssh_key_path|${SSH_KEY_FILE}|g;" Vagrantfile

    echo vagrant up --provider=virtualbox

    #bootstrap-*.sh
    sed -i.bak "s|__inv_file|${INVENTORY_FILE}|g;s|__adds|-vvv|g;s|__iface|eth1|g;s|__username|vagrant|g" bootstrap-*.sh
    #docker-build.sh
    sed -i.bak "s|__inv_file|${INVENTORY_FILE}|g;s|__adds|-vvv|g;s|__iface|eth1|g;s|__username|vagrant|g" docker-build.sh
    #marathon-deploy.sh
    sed -i.bak "s|__inv_file|${INVENTORY_FILE}|g;s|__adds|-vvv|g;s|__iface|eth1|g;s|__username|vagrant|g" marathon-deploy.sh  
}

function provision_azure() {
    source source.azure
    echo "Temporary unavailable.. We working on this..."
    exit 1
#    ansible-playbook -i windows_azure.py $VERBOSITY provision/wa-docker-registry.yaml -e location=\""$LOCATION"\" -e username=$BOXUSERNAME -e ports=$DOCKER_PORTS -e password=$PASSWD -e cluster=$CLUSTER -e storage=$STORAGE_NAME -e cert_path=$CER_FILE -e pem_file=$PEM_FILE
#    ./windows_azure.py --refresh-cache > /dev/null
#    sed -i.bak "s|__inv_file|windows_azure.py|g;s|__adds|$VERBOSITY --private-key $PEM_FILE|g;s|__iface|eth0|g;s|__username|$BOXUSERNAME|g" bootstrap-*.sh
#    sed -i.bak "s|__inv_file|windows_azure.py|g;s|__adds|$VERBOSITY --private-key $PEM_FILE|g;s|__iface|eth0|g;s|__username|$BOXUSERNAME|g" docker-build.sh
#    sed -i.bak "s|__inv_file|windows_azure.py|g;s|__adds|$VERBOSITY --private-key $PEM_FILE|g;s|__iface|eth0|g;s|__username|$BOXUSERNAME|g" marathon-deploy.sh
}

function prepare_files() {
    cd infrastructure
    rm Vagrantfile
    rm -rf .vagrant
    cp provision/Vagrantfile.tmpl ./Vagrantfile
    cp provision/playbook.yml ./

    rm bootstrap-*.sh
    rm docker-build.sh
    rm marathon-deploy.sh
    cp bootstrap/bootstrap*.sh ./
    cp bootstrap/docker-build.sh ./
    cp bootstrap/marathon-deploy.sh ./
    echo "Ready to provision $MASTER master(s) and $SLAVE slave(s) to $TARGET"
}


# TODO set SOFT_CLOUD_PROVIDER

if [ $# = 0 ]; then
    print_usage
    exit
fi


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

if [ ${MASTER} -eq 0 ]; then
   echo "Number of master nodes is odd, should be even number."
   print_usage
   exit
fi

source infrastructure/source.global
INVENTORY_FILE=".vagrant\/provisioners\/ansible\/inventory\/vagrant_ansible_inventory"


case "$TARGET" in
    "do")
        prepare_files
	provision_digital_ocean $MASTER $SLAVE
       ;;
    "digital_ocean")
        prepare_files
	provision_digital_ocean $MASTER $SLAVE
       ;;
    "aws")
        prepare_files
	provision_aws $MASTER $SLAVE
	   ;;
    "ec2")
        prepare_files
	provision_aws $MASTER $SLAVE
       ;;
    "vagrant")
        prepare_files
	provision_virtualbox $MASTER $SLAVE
       ;;
    "virtualbox")
        prepare_files
	provision_virtualbox $MASTER $SLAVE
       ;;
    "azure")
        prepare_files
	provision_azure $MASTER $SLAVE
       ;;
    *)
        print_usage
        exit
esac

rm *.bak

wait

