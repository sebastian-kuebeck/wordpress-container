#!/usr/bin/env bash

# Installs the Wordpress CLI
#
# see: https://make.wordpress.org/cli/
#
# derived from https://github.com/docker-library/wordpress/blob/master/cli/php8.3/alpine/Dockerfile

set -euxo pipefail

WORDPRESS_CLI_VERSION=2.11.0

# https://make.wordpress.org/cli/2018/05/31/gpg-signature-change/
# pub   rsa2048 2018-05-31 [SC]
#       63AF 7AA1 5067 C056 16FD  DD88 A3A2 E8F2 26F0 BC06
# uid           [ unknown] WP-CLI Releases <releases@wp-cli.org>
# sub   rsa2048 2018-05-31 [E]
WORDPRESS_CLI_GPG_KEY=63AF7AA15067C05616FDDD88A3A2E8F226F0BC06
WORDPRESS_CLI_SHA512=adb12146bab8d829621efed41124dcd0012f9027f47e0228be7080296167566070e4a026a09c3989907840b21de94b7a35f3bfbd5f827c12f27c5803546d1bba

curl -o /usr/local/bin/wp.gpg -fL "https://github.com/wp-cli/wp-cli/releases/download/v${WORDPRESS_CLI_VERSION}/wp-cli-${WORDPRESS_CLI_VERSION}.phar.gpg"; \
GNUPGHOME="$(mktemp -d)"; export GNUPGHOME
gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$WORDPRESS_CLI_GPG_KEY"
gpg --batch --decrypt --output /usr/local/bin/wp /usr/local/bin/wp.gpg
gpgconf --kill all
rm -rf "$GNUPGHOME" /usr/local/bin/wp.gpg; unset GNUPGHOME

echo "$WORDPRESS_CLI_SHA512 */usr/local/bin/wp" | sha512sum -c -; \
chmod +x /usr/local/bin/wp; \