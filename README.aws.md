### AWS Credentials

copy ./conf/source.aws.example into ./conf/source.aws

Set the following properties:

        AWS_KEY_ID='<KEY>'
        AWS_ACCESS_KEY='<ACCESS_KEY>'
        AWS_KEYPAIR_NAME='<KEY NAME>'
        AWS_AMI='<AMI>'
        AWS_INSTANCE_TYPE='t2.medium'
        AWS_ROOT_PARTITION_SIZE=50
        AWS_REGION='us-west-1'
        AWS_SECURITY_GROUPS="default,<GROUP WHERE SSH IS ALLOWED>"
        AWS_SSH_USERNAME='<USERNAME TO SSH TO VIRTUAL MACHINE'
        SSH_KEY_FILE=<FULL PATH TO PEM FILE>

##### AWS_KEY_ID and AWS_ACCESS_KEY

* Open [the IAM console](https://console.aws.amazon.com/iam/home?#home)
 * In the navigation pane, choose Users.
 * Choose your IAM user name (not the check box).
 * Choose the Security Credentials tab and then choose Create Access Key.

To see your access key, choose Show User Security Credentials. Your credentials will look something like this:
```
  Access Key ID: AKIAIOSFODNN7EXAMPLE
  Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```
Choose Download Credentials, and store the keys in the ```source.aws``` file in ```AWS_KEY_ID=<KEY>``` and ```AWS_ACCESS_KEY=<AWS_ACCESS_KEY>```. 

##### AWS_KEYPAIR_NAME and SSH_KEY_FILE
SSH Keys or so called in AWS Console ```[Network & Security] > [Key Pairs]```

The keys are used to replace password based authentication. EC2 requires you to setup a keypair in management console. If you do not have keypair, it's easy to create new one open ```[AWS Console] > [EC2]``` then in left pane ```[Network & Security] > [Key Pairs]``` in case there are existing key pairs in your AWS account you can use it as well. We sugest you to name a new key pair ```PintoStack```. And save the key file in save place and put the path to you key file in ```source.aws``` for example it looks like this ```SSH_KEY_FILE='~/Downloads/PintoStack.pem.txt'``` and ```AWS_KEYPAIR_NAME='PintoStack'```.
> IMPORTANT: Please note that keypairs are also region specific and to read more please follow the [this link](http://docs.aws.amazon.com/opsworks/latest/userguide/security-ssh-access.html).

put your keyfile into ```conf``` folder and set SSH_KEY_FILE to ```/pintostack/conf/<myfile>.pem``` to allow working with it from Pintostack's container.

##### AWS_AMI and AWS_SSH_USERNAME

AMI name is the name of image that is used as a source for your virtual instances. So if you chose a different region than we sugested in default ```source.aws``` like ```AWS_REGION='us-west-2'``` you need to change default ```AWS_AMI='ami-5189a661'```. To do so, open this [link](https://cloud-images.ubuntu.com/locator/ec2/) and type for example if you would like to find out the AMI-ID for the latest release of “LTS” Ubuntu to run on a “64″ bit “ebs” instance in the “us-east” region, you would search for ```lts 64 us-east ebs```.
>NOTICE: You can try other options like [archlinux](https://www.uplinklabs.net/projects/arch-linux-on-ec2/), or even [BSD](http://www.daemonology.net/freebsd-on-ec2/) but it was not tested.

For easy start choose ```ami-df6a8b9b``` with username ```ubuntu``` for region ```us-west-1```

##### AWS_ROOT_PARTITION_SIZE

Choose volume for root partition, 50 GB works well.

##### AWS_REGION

Before starting the deployment process you might select a region where it would reside we sugest you to use default one from ```source.aws``` file ```AWS_REGION='us-west-2'```. But EC2 allows you to select from number of available regions.
Configuration would require from you the name of region you selected, lilke, us-west-1, or eu-east-2 put in ```source.aws``` file like ```AWS_REGION='us-west-2'```
> IMPORTANT: Remember that AWS_AMI and AWS_SECURITY_GROUPS are region specific.

##### AWS_SECURITY_GROUPS

Network and Firewall so called in AWS Console ```[Network & Security] > [Security Groups]```

We sugest you create two default security groups for your cluster with names ```default``` and ```allow-ssh``` to do so open ```[AWS Console] > [EC2]``` then in left pane ```[Network & Security] > [Security Groups]``` than create two with names ```default``` and ```allow-ssh```
* After security groups has bin created copy ```Group ID``` of that one with name ```default``` and click edit and add the only one inbound rule to allow local traffic in VPC with ```Type: All traffic; Source: Custom IP [put here Group ID]``` and press ```save```.
* Now chose the one named ```allow-ssh``` and the same way add three inbound rules to allow ```SSH ,TCP port 5050, TCP port 8080``` and save.

Remember security groups you want to apply to your new instances should be listed in ```source.aws``` file in ```AWS_SECURITY_GROUPS="default,allow-ssh"```
>NOTICE: For more information on AWS Security Groups look [here](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html).