#!/usr/bin/env bash

# Installs the Wordpress CLI
#
# see: https://make.wordpress.org/cli/
#
# derived from https://github.com/docker-library/wordpress/blob/master/cli/php8.5/alpine/Dockerfile

set -euxo pipefail

WORDPRESS_CLI_VERSION=2.12.0

# https://make.wordpress.org/cli/2018/05/31/gpg-signature-change/
# pub   rsa2048 2018-05-31 [SC]
#       63AF 7AA1 5067 C056 16FD  DD88 A3A2 E8F2 26F0 BC06
# uid           [ unknown] WP-CLI Releases <releases@wp-cli.org>
# sub   rsa2048 2018-05-31 [E]
WORDPRESS_CLI_GPG_KEY=63AF7AA15067C05616FDDD88A3A2E8F226F0BC06
WORDPRESS_CLI_SHA512=be928f6b8ca1e8dfb9d2f4b75a13aa4aee0896f8a9a0a1c45cd5d2c98605e6172e6d014dda2e27f88c98befc16c040cbb2bd1bfa121510ea5cdf5f6a30fe8832

curl -o /usr/local/bin/wp.gpg -fL "https://github.com/wp-cli/wp-cli/releases/download/v${WORDPRESS_CLI_VERSION}/wp-cli-${WORDPRESS_CLI_VERSION}.phar.gpg"; \
GNUPGHOME="$(mktemp -d)"; export GNUPGHOME
gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$WORDPRESS_CLI_GPG_KEY"
gpg --batch --decrypt --output /usr/local/bin/wp /usr/local/bin/wp.gpg
gpgconf --kill all
rm -rf "$GNUPGHOME" /usr/local/bin/wp.gpg; unset GNUPGHOME

echo "$WORDPRESS_CLI_SHA512 */usr/local/bin/wp" | sha512sum -c -; \
chmod +x /usr/local/bin/wp; \