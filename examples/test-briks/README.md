# Running Integration Tests

Create TestBuild in TeamCity with folowing steps after checkout REPO/branch

## Best practice for provisioning system

* Command line: Custom Script: Create provider configuration and put ssh keys to folder you can use ```examples/test-briks/set-source.sh aws AWS_KEY_ID put-key-here```
* Command line: Custom Script: Create cluster configuration ```examples/test-briks/set-source.sh global SLAVES 3```
* Command line: Custom Script: Run ```vagrant up --provider=[provider]```
* Command line: Executable with parametrs: You can rerun ansible with debug executing ```examples/test-briks/worldplaybook-verbose.sh```
* Command line: Executable with parametrs: Fix tty issue ```examples/test-briks/fix-tty.sh```
* Add more steps here...
* Command line: Custom Script: After all done run ```vagrant destroy -f``` to terminate all hosts

## Best practice for docker containers and services

* Command line: Custom Script: Create provider configuration and put ssh keys to folder you can use ```examples/test-briks/set-source.sh aws AWS_KEY_ID put-key-here```
* Command line: Custom Script: Bring up the world ```vagrant up --provider=[provider]`
* Command line: Executable with parametrs: Build container ```examples/test-briks/docker-push-verbose.sh <container_name>``` 
* Command line: Executable with parametrs: Start marathon app ```examples/test-briks/marathon-push-verbose.sh <service_name>.json```
* Command line: Executable with parametrs: Fix tty issue ```examples/test-briks/fix-tty.sh```
* Command line: Executable with parametrs: Get service port from consul and try to connect ```examples/test-briks/wait-service-registration.sh <service_name>```
* Add more steps here...
* Command line: Custom Script: After all done run ```vagrant destroy -f``` to terminate all hosts
