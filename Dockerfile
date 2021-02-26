FROM openjdk:latest

ARG JMETER_VERSION="5.4.1"
COPY ./apache-jmeter-${JMETER_VERSION}.tgz /tmp

ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin

RUN mkdir -p /opt \
    && tar -xzf /tmp/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
    && rm -rf /tmp/apache-jmeter-${JMETER_VERSION}.tgz

ENV PATH $PATH:$JMETER_BIN

ENV JMETER_REMOTE_HOSTS 127.0.0.1
ENV JMETER_SERVER_HOST 127.0.0.1
ENV JMETER_RUN_MODEL master

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

WORKDIR	${JMETER_HOME}
ENTRYPOINT ["/entrypoint.sh"]