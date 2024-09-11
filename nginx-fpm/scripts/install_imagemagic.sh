#!/usr/bin/env bash

# Installs Wordpress specific version of imagemagic
#
# derived from https://github.com/docker-library/wordpress/blob/master/latest/php8.3/fpm/Dockerfile

set -euxo pipefail
savedAptMark="$(apt-mark showmanual)"

# https://pecl.php.net/package/imagick
# https://github.com/Imagick/imagick/commit/5ae2ecf20a1157073bad0170106ad0cf74e01cb6 (causes a lot of build failures, but strangely only intermittent ones 🤔)
# see also https://github.com/Imagick/imagick/pull/641
# this is "pecl install imagick-3.7.0", but by hand so we can apply a small hack / part of the above commit

curl -fL -o imagick.tgz 'https://pecl.php.net/get/imagick-3.7.0.tgz'
echo '5a364354109029d224bcbb2e82e15b248be9b641227f45e63425c06531792d3e *imagick.tgz' | sha256sum -c -
tar --extract --directory /tmp --file imagick.tgz imagick-3.7.0
grep '^//#endif$' /tmp/imagick-3.7.0/Imagick.stub.php
test "$(grep -c '^//#endif$' /tmp/imagick-3.7.0/Imagick.stub.php)" = '1'
sed -i -e 's!^//#endif$!#endif!' /tmp/imagick-3.7.0/Imagick.stub.php
grep '^//#endif$' /tmp/imagick-3.7.0/Imagick.stub.php && exit 1 || :
docker-php-ext-install /tmp/imagick-3.7.0
rm -rf imagick.tgz /tmp/imagick-3.7.0

# some misbehaving extensions end up outputting to stdout 🙈 (https://github.com/docker-library/wordpress/issues/669#issuecomment-993945967)
out="$(php -r 'exit(0);')"
[ -z "$out" ]
err="$(php -r 'exit(0);' 3>&1 1>&2 2>&3)"
[ -z "$err" ]

extDir="$(php -r 'echo ini_get("extension_dir");')"
[ -d "$extDir" ]
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
apt-mark auto '.*' > /dev/null
apt-mark manual $savedAptMark
ldd "$extDir"/*.so \
    | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' \
    | sort -u \
    | xargs -r dpkg-query --search \
    | cut -d: -f1 \
    | sort -u \
    | xargs -rt apt-mark manual

apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false
rm -rf /var/lib/apt/lists/*

! { ldd "$extDir"/*.so | grep 'not found'; }
# check for output like "PHP Warning:  PHP Startup: Unable to load dynamic library 'foo' (tried: ...)
err="$(php --version 3>&1 1>&2 2>&3)"
[ -z "$err" ]
