#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/nomp.sh | bash
#
#########################################################


# Install Nodejs
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install NOMP
sudo apt install -y build-essential
wget https://raw.githubusercontent.com/jacknab/scripts/main/nomp_.tar.gz
tar -xvzf nomp_.tar.gz
rm nomp_.tar.gz
sudo apt-get install -y redis-server
service redis-server restart

# curl -s https://raw.githubusercontent.com/jacknab/scripts/main/nomp_patch.sh | bash


