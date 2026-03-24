#!/usr/bin/env bash

# Downloads Wordpress from https://wordpress.org and unpacks ist to /usr/source
#
# derived from https://github.com/docker-library/wordpress/blob/master/latest/php8.5/fpm/Dockerfile

set -euxo pipefail

version='6.9.4'
sha1='018542f4c3e15db0d8e38aaf0fcf1b5dc56dbb79'

curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-$version.tar.gz"
echo "$sha1 *wordpress.tar.gz" | sha1sum -c -
# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
tar -xzf wordpress.tar.gz -C /usr/src/
rm wordpress.tar.gz
chown -R www-data:www-data /usr/src/wordpress
mkdir wp-content

for dir in /usr/src/wordpress/wp-content/*/ cache; do
    dir="$(basename "${dir%/}")"
    mkdir "wp-content/$dir"
done;
chown -R www-data:www-data wp-content
chmod -R 1777 wp-content