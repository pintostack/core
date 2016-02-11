FROM pintostack/pintostack-base-mesos

RUN mkdir -p /etc/mesos-master
RUN echo in_memory | dd of=/etc/mesos-master/registry
RUN echo docker > /etc/mesos-slave/containerizers
RUN echo 600secs > /etc/mesos-slave/executor_registration_timeout

ENTRYPOINT ["mesos-master"]




