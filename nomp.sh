#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
#
#########################################################

# Install Nodejs
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs

# Install NOMP
sudo apt install -y build-essential
sudo mkdir nomp
git clone https://github.com/nomp/node-open-mining-portal.git nomp
cd nomp
# wget https://raw.githubusercontent.com/jacknab/scripts/main/nomp.tar.gz
# tar -xvzf nomp.tar.gz
sudo apt-get install -y redis-server
service redis-server restart

# curl -s https://raw.githubusercontent.com/jacknab/scripts/main/nomp_patch.sh | bash


