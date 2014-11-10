FROM ubuntu:14.04

# Detect a squid deb proxy on the docker host
ADD scripts/detect_squid_deb_proxy /tmp/detect_squid_deb_proxy
RUN /tmp/detect_squid_deb_proxy

# Get some packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y git libapache2-mod-php5 php5-curl

# Install full-text-rss
RUN rm -r /var/www/html
ADD full-text-rss /var/www/html

# Setup cache dir
RUN chown www-data /var/www/html/cache
RUN install -o www-data -d /var/www/html/cache/rss

# Configure
ADD custom_config.php /var/www/html/custom_config.php

# TODO
# CI?

# Run apache
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
