FROM ubuntu:14.04

# for busting docker caches, simply increment this dummy variable
ENV docker_cache_bust 1

# Detect a squid deb proxy on the docker host
ADD scripts/detect_squid_deb_proxy /tmp/detect_squid_deb_proxy
RUN /tmp/detect_squid_deb_proxy

# Disable initctl as it conflicts with docker:
# https://github.com/docker/docker/issues/1024
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s -f /bin/true /sbin/initctl

# Get some packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
  libapache2-mod-php5 php5-curl php5-tidy php5-apcu \
  python-setuptools rsyslog \
  curl

# Install supervisord
RUN easy_install supervisor
ADD files/supervisor/supervisord.conf /etc/supervisord.conf

# Setup cron
ADD files/supervisor/conf.d /etc/supervisor/conf.d
ADD assets/update_url /tmp/update_url
RUN (echo "0 0 * * * /usr/bin/curl -s $(cat /tmp/update_url)"; \
  echo "@reboot sleep 5 && /usr/bin/curl -s $(cat /tmp/update_url)") \
  | crontab -u www-data -

# Install full-text-rss
RUN rm -r /var/www/html
ADD assets/full-text-rss /var/www/html

# Setup cache dir
RUN chown www-data /var/www/html/cache
RUN install -o www-data -d /var/www/html/cache/rss

# Configure full-text-rss
ADD assets/custom_config.php /var/www/html/custom_config.php
RUN chgrp www-data /var/www/html/site_config

CMD ["supervisord",  "-c", "/etc/supervisord.conf", "-n"]
