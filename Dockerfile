FROM jruby:9.1-jre-alpine

MAINTAINER Jeremy Winters jeremy.winters@full360.com

RUN apk add --no-cache \
      bash \
      git \
      wget

#set time zone
RUN mv /etc/localtime /etc/localtime.bak ; ln -s /usr/share/zoneinfo/UTC /etc/localtime

USER root

RUN gem install sneaql

# java deps
RUN mkdir /jars
ADD java/RedshiftJDBC4-1.1.6.1006.jar /jars/RedshiftJDBC4-1.1.6.1006.jar

# ruby deps
ADD ruby/git_clone_url.rb /usr/sbin/git_clone_url.rb
ADD ruby/source_biscuit.rb /usr/sbin/source_biscuit.rb

# biscuit binary is used, not built from source
ADD biscuit/biscuit /usr/sbin/biscuit
RUN chmod 755 /usr/sbin/biscuit

# this is the entry point
ADD bash/runner.sh /usr/sbin/runner.sh
RUN chmod 755 /usr/sbin/runner.sh
ENTRYPOINT ["/usr/sbin/runner.sh"]

# should be more than sufficient for transforms without
# large recordset operations.
ENV JRUBY_OPTS=-J-Xmx2048m