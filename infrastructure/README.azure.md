# About

This is detailed description on how to deploy cluster in Azure Cloud.

## Pre-requisites

You would need several libraries installed on machine to work with azure cloud provider. Install it with pip as described below

```
pip install boto
pip install azure==0.11.1
```

## Configuring Azure for your cluster

> Location

You now need to configure several items that would be used by the cluster. First of all you need to choose where your machines will reside. Azure provides you with several options among them are Central US, and [many more](https://azure.microsoft.com/en-us/regions/). This will be later used during resources configuration.

> Virtual network

Now open [azure portal](http://manage.windowsazure.com/) and navigate to network management, and create new virtual network. When creating network it will be required to specify region. The network will be later used to group your virtual boxes together.

> Storage

Navigate to storage management in azure portal, and create new storage. Please configure it depending on your region selection and required availability. You might want to use [this article](http://support.rightscale.com/09-Clouds/Microsoft_Azure/Tutorials/Set_up_Microsoft_Azure_Cloud_Storage/) to get better understanding on how to create storage.

> Management certificates

In order to access management portal from ansible scripts you would need to generate management certificates and assign them to your subscription. Please generate pair of cer and pem files (first [generate private/public key pair](https://help.github.com/articles/generating-ssh-keys/) and then [convert](http://askubuntu.com/questions/465183/how-to-convert-rsa-key-to-pem-using-x-509-standard) ). Remove r/w/x permissions from group and others from certificate files, you can use chmod command to do that.

It's time to upload the cer file to the management console. Go to [portal](https://manage.windowsazure.com/) and there navigate Settings(at the bottom of the list on left hand side), then open management tab and upload management certificate.

> Subscription id

You should also get subscription id. Here us http://blogs.msdn.com/b/mschray/archive/2015/05/13/getting-your-azure-guid-subscription-id.aspx link that can help you to do that.

> Linux box ssh keys

Create a pem and cer pair for your linux boxes, this files are later used to log into your machines. Please keep both in secret and set proper file permissions. To get more information about keys find section on SSH keys [here](http://www.windowsazure.com/en-us/manage/linux/tutorials/intro-to-linux/). As you can see there two different sets of key files are in use, the first one generate to perform remote access to the azure portal, and second keys will be used to login into the boxes. It's better to have separate keys.

## Configure VPC details

### azure.source

You can find the file under <git repo root>/infrastructure/azure.source. File structure is very simple. Please provide full path to cer and pem files. Do not forget to update location, so virtual boxes would be created in proper location.

Next items could be changed from azure.source and corresponding yml files (./infrastructure/provision/wa-*.yml):
* BOXUSERNAME=user name. This user account will be created on new virtual boxes
* PASSWD=user password, this password will be set on your machines, not your azure instance password
* STORAGE_NAME=storage name you created before, storage that is used to keep various data
* CLUSTER=virtual network you created before, it will be used to interconnect machines within cluster

You might also want to amend next parameters:
* MASTER_PORTS/SLAVE_PORTS/DOCKER_PORTS=ports to open to outer world, this setting could be later changed from portal
* instance size, should be changed from yml
* image name, should be changed from yml

## Provisioning

Open terminal window and define two environment variables for you session:
```
AZURE_CERT_PATH=<full path to management certificate pem file>
AZURE_SUBSCRIPTION_ID=<subscription id>
```

now it's time to run provision sh file
```
./provision.sh --target=azure --master=3 --slave=11
```

## Infrastructure

Once you finished provisioning virtual resources you can start deploying the cluster on it.
[Please follow instructions](README.md#bootstrap).
