1. submit jmeter app into marathon and scale it.

ssh to one of the slaves and run pintostack/jmeter-test container

docker run -it --net=host pintostack/jmeter-test bash
consul-lookup -t --consul=http://master-1.node.consul:8500/ jmeter

run test w/o remotes
java -jar ./apache-jmeter-2.13/bin/ApacheJMeter.jar -n -t /test.jmx

run with remotes
java -jar ./apache-jmeter-2.13/bin/ApacheJMeter.jar -n -t /test.jmx -R 172.31.0.22:31412
