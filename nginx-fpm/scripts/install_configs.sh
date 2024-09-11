#!/usr/bin/env bash

# Moves configuration files to their destination
#
# derived from https://github.com/docker-library/wordpress/blob/master/latest/php8.3/fpm/Dockerfile

set -euxo pipefail

mv configs/opcache-recommended.ini /usr/local/etc/php/conf.d/opcache-recommended.ini
mv configs/error-logging.ini /usr/local/etc/php/conf.d/error-logging.ini

mv configs/nginx.conf /etc/nginx/nginx.conf
mv configs/default.conf /etc/nginx/conf.d/default.conf

mv  configs/wordpress.cron /etc/cron.d/wordpress-cron
crontab /etc/cron.d/wordpress-cron

mv configs/encab.yml /etc/encab.yml

mv configs/wp-config.php /usr/src/wordpress/wp-config-docker.php
chown www-data:www-data /usr/src/wordpress/wp-config-docker.php

