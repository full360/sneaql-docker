FROM jruby:9.1-jre-alpine


LABEL build.publish.majorversion="0.1.5"
LABEL build.publish.minorversion="0.0.27"
LABEL build.publish.imagebase="jruby"
LABEL build.publish.sneaqlgemversion="0.0.27"

ARG SNEAQL_GEM_VERSION=0.0.27
ENV SNEAQL_GEM_VERSION=${SNEAQL_GEM_VERSION}
ENV LANG C.UTF-8
ENV JRUBY_OPTS="-J-Djruby.thread.pool.enabled=true -J-XX:+UnlockExperimentalVMOptions -J-XX:+UseCGroupMemoryLimitForHeap -J-XX:MaxRAMFraction=1 -J-Xms256M -J-Ddeployment.security.SSLv2Hello=false -J-Ddeployment.security.SSLv3=false -J-Ddeployment.security.TLSv1=false -J-Ddeployment.security.TLSv1.1=false -J-Ddeployment.security.TLSv1.2=true"

MAINTAINER Rohit Amarnath rohit.amarnath@full360.com

# Install required packages
RUN set -ex \
      && \
      apk update && \
      apk add --no-cache \
      bash \
      ca-certificates \
      curl \
      git \
      gnupg \
      groff \
      less \
      ncurses \
      make \
      openssl \
      python \
      py-pip \
      tar \
      unzip

# Install Biscuit
RUN curl  -s -L -o /tmp/biscuit.tar.gz \
       https://github.com/dcoker/biscuit/releases/download/v0.1.3/biscuit-linux_386.tgz \
    && tar zxf /tmp/biscuit.tar.gz -C /usr/local/bin \
    && rm /tmp/biscuit.tar.gz

# Install and upgrade Pip * AWS CLI
RUN mkdir -p /aws && \
    pip install --upgrade pip  && \
    pip install awscli  && \
    apk --purge -v del py-pip


USER root

RUN gem install sneaql -v ${SNEAQL_GEM_VERSION}; gem install sneaql-aws

# java deps
ADD java/RedshiftJDBC4-1.1.6.1006.jar /jars/RedshiftJDBC4-1.1.6.1006.jar

# this is the entry point
ADD bash/runner.sh /usr/sbin/runner.sh
RUN chmod 755 /usr/sbin/runner.sh
ENTRYPOINT ["/usr/sbin/runner.sh"]

# should be more than sufficient for transforms without
# large recordset operations.
ENV JRUBY_OPTS=-J-Xmx4096m
