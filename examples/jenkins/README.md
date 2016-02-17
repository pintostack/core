# Jenkins in cloud
1. submit an app into marathon (marathon-push.sh jenkins.json)
2. Enable security and set JNLP TCP port to fixed, specify one of free ports allocated by Marathon.
3. install mesos plugin
4. Configure new cloud and use Mesos Cloud
5. use /usr/lib/libmesos.so
6. set mesos master url and jenkins url
7. Use docker images for slaves, keep in mind - you need an image with java installed. You can use: java:8-jdk for example.
8. Create a new job with bash step in Jenkins and let it use you new type of slaves. Check 'use-on-demand'
9. Start this job.