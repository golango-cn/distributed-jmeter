FROM alpine:3.12

ARG JMETER_VERSION="5.4.1"

ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin

ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

# RUN mkdir -p /opt \
#     && tar -xzf /tmp/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
#     && rm -rf /tmp/apache-jmeter-${JMETER_VERSION}.tgz


ARG TZ="Europe/Amsterdam"
RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies


ENV PATH $PATH:$JMETER_BIN

ENV JMETER_REMOTE_HOSTS 127.0.0.1
ENV JMETER_SERVER_HOST 127.0.0.1
ENV JMETER_RUN_MODEL master

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

WORKDIR	${JMETER_HOME}
ENTRYPOINT ["/entrypoint.sh"]