FROM java:8-jdk

MAINTAINER Yuri G

# Temporarily use pre-built libmesos instead of building it from scratch
RUN curl -SL d1e4cwyo3j98xy.cloudfront.net/libmesos-0.25.0.tgz \
	| tar -xzC /root

RUN cp /root/libmesos-0.25.0/* /usr/lib && \
	rm -rf /root/libmesos-0.25.0

# Create symlinks for libmesos
RUN	ln -s /usr/lib/libmesos-0.25.0.so /usr/lib/libmesos.so && \
	ln -s /usr/lib/libfixed_resource_estimator-0.25.0.so /usr/lib/libfixed_resource_estimator.so && \
	ln -s /usr/lib/libmesos-0.25.0.so /usr/local/lib/libmesos-0.25.0.so && \
	ln -s /usr/lib/libmesos.so /usr/local/lib/libmesos.so && \
	ln -s /usr/lib/libfixed_resource_estimator-0.25.0.so /usr/local/lib/libfixed_resource_estimator-0.25.0.so && \
	ln -s /usr/lib/libfixed_resource_estimator.so /usr/local/lib/libfixed_resource_estimator.so

RUN wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war -O /tmp/jenkins.war

RUN apt-get update && apt-get -y install libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev jq

COPY ./bootstrap.sh /tmp/bootstrap.sh
RUN chmod +x /tmp/bootstrap.sh

EXPOSE 8080

CMD /tmp/bootstrap.sh