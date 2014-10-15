FROM ubuntu:14.04

# Detect a squid deb proxy on the docker host
ADD scripts/detect_squid_deb_proxy /tmp/detect_squid_deb_proxy
RUN /tmp/detect_squid_deb_proxy

# Get some packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y git libapache2-mod-php5

# git clone https://bitbucket.org/fivefilters/full-text-rss.git



