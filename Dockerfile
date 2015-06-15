

FROM debian:jessie

RUN echo version 0.1

RUN echo "deb http://www.apache.org/dist/cassandra/debian 21x main" 	 > /etc/apt/sources.list.d/cassandra.list
RUN echo "deb-src http://www.apache.org/dist/cassandra/debian 21x main" >> /etc/apt/sources.list.d/cassandra.list

RUN gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
RUN gpg --export --armor F758CE318D77295D | apt-key add -
RUN gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
RUN gpg --export --armor 2B5C1B00 | apt-key add -
RUN gpg --keyserver pgp.mit.edu --recv-keys 0353B12C
RUN gpg --export --armor 0353B12C | apt-key add -

RUN apt-get update

RUN apt-get -y dist-upgrade

RUN apt-get -y install mlocate
RUN apt-get -y install cassandra
RUN apt-get -y install supervisor
RUN apt-get -y install ssh
RUN mkdir /var/run/sshd
RUN apt-get -y install netcat

ADD src/supervisord.conf /etc/supervisord.conf

RUN rm -f /etc/security/limits.d/cassandra.conf

ADD src/start.sh /usr/local/bin/start

ADD init.sql /tmp/init.cql

RUN /bin/bash -c "( /usr/local/bin/start & ) ; while ! nc -z localhost 9042; do sleep 5 ; echo waiting ; done ; cat /tmp/init.cql | cqlsh ; sleep 12"

RUN updatedb

EXPOSE 7199 7000 7001 9160 9042
EXPOSE 22 8012 61621
USER root
CMD start


