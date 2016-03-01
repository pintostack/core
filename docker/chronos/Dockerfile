FROM pintostack/pintostack-base-mesos

RUN apt-get install -y chronos=2.4.0-0.1.20151007110204.ubuntu1404 jq

RUN cat /usr/bin/chronos > /tmp/c
RUN echo "#!/bin/bash" > /usr/bin/chronos
RUN echo "function ulimit {" >> /usr/bin/chronos
RUN echo "echo 'stubulimit'" >> /usr/bin/chronos
RUN echo "}" >> /usr/bin/chronos
RUN echo "" >> /usr/bin/chronos
RUN cat /tmp/c >> /usr/bin/chronos

COPY ./bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh

EXPOSE 8080

CMD /bootstrap.sh


