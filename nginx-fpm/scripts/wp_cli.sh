#!/usr/bin/env bash
set -e

# Runs wp as user www-data.
# Helper script to run wp as root. 
 
sudo -E -g www-data -u www-data wp $@
