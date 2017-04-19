FROM jruby:9.1-jre-alpine


LABEL build.publish.majorversion="13"
LABEL build.publish.minorversion="0.0.13"
LABEL build.publish.imagebase="jruby"

ARG SNEAQL_GEM_VERSION
LABEL sneaql.gem.version=${SNEAQL_GEM_VERSION}

MAINTAINER Jeremy Winters jeremy.winters@full360.com

RUN apk add --no-cache \
      bash \
      git \
      wget \
      curl \
      # Install biscuit
      && curl  -s -L -o /tmp/biscuit.tar.gz \
         https://github.com/dcoker/biscuit/releases/download/v0.1.3/biscuit-linux_386.tgz \
      && tar zxf /tmp/biscuit.tar.gz -C /usr/local/bin \
      && rm /tmp/biscuit.tar.gz

#set time zone
RUN mv /etc/localtime /etc/localtime.bak ; ln -s /usr/share/zoneinfo/UTC /etc/localtime

USER root

RUN gem install sneaql -v ${SNEAQL_GEM_VERSION}

# java deps
ADD java/RedshiftJDBC4-1.1.6.1006.jar /jars/RedshiftJDBC4-1.1.6.1006.jar

# this is the entry point
ADD bash/runner.sh /usr/sbin/runner.sh
RUN chmod 755 /usr/sbin/runner.sh
ENTRYPOINT ["/usr/sbin/runner.sh"]

# should be more than sufficient for transforms without
# large recordset operations.
ENV JRUBY_OPTS=-J-Xmx2048m
