#!/usr/bin/env bash

# Downloads Wordpress from https://wordpress.org and unpacks ist to /usr/source
#
# derived from https://github.com/docker-library/wordpress/blob/master/latest/php8.3/fpm/Dockerfile

set -euxo pipefail

version='6.6.2'
sha1='7acbf69d5fdaf804e3db322bad23b08d2e2e42ec'

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