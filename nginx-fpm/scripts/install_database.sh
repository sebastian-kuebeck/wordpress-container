#!/usr/bin/env bash

# Runs wp core install to set up the database and create an admin user
# if the database is empty.
#
# see: https://developer.wordpress.org/cli/commands/core/install/

if ! wp-cli core is-installed ; then
    set -e

    wp-cli core install \
        --url=$WP_URL \
        --title="$WP_TITLE" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --locale=$WP_LOCALE \
        --skip-email \
        --quiet 2>>/dev/null

    echo "Database successfully installed."
else
    echo "Database already installed."
fi
