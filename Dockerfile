FROM ubuntu:14.04

# for busting docker caches, simply increment this dummy variable
ENV docker_cache_bust 1

# Detect a squid deb proxy on the docker host
ADD scripts/detect_squid_deb_proxy /tmp/detect_squid_deb_proxy
RUN /tmp/detect_squid_deb_proxy

# Get some packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y git libapache2-mod-php5 php5-curl php5-tidy php5-apcu

# Install full-text-rss
RUN rm -r /var/www/html
ADD full-text-rss /var/www/html

# Setup cache dir
RUN chown www-data /var/www/html/cache
RUN install -o www-data -d /var/www/html/cache/rss

# Configure
ADD password /tmp/password
ADD custom_config.php /tmp/custom_config.php
RUN cat /tmp/custom_config.php \
  | sed -e 's/@PASSWORD@/'"$(cat /tmp/password)"'/' \
  > /var/www/html/custom_config.php \
  && rm /tmp/password /tmp/custom_config.php

# TODO
# CI?

# Run apache
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
