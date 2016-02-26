# Add more slaves to your running cluster

To add slave to your running cluster run ./slave_add.sh
This will execute Vagrant for the new machine without provisioning.
And after machine will be UP run add-slave.yml playbook
so in several minutes you wil notice a new slave macine in mesos UI
