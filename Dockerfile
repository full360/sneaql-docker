FROM jruby:9.1-jre-alpine

MAINTAINER Jeremy Winters jeremy.winters@full360.com

RUN apk add --no-cache \
      bash \
      git

#set time zone
RUN mv /etc/localtime /etc/localtime.bak ; ln -s /usr/share/zoneinfo/UTC /etc/localtime

USER root

RUN gem install sneaql

ADD bash/runner.sh /usr/sbin/runner.sh
RUN chmod 755 /usr/sbin/runner.sh

ADD java/RedshiftJDBC4-1.1.6.1006.jar /tmp/RedshiftJDBC4-1.1.6.1006.jar
ADD ruby/git_clone_url.rb /tmp/git_clone_url.rb

ENV JRUBY_OPTS=-J-Xmx2048m

ENTRYPOINT ["/usr/sbin/runner.sh"]