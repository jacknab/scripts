#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
#
#########################################################
# Install Nodejs
curl -fsSL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install nodejs=10.19.0-1nodesource1
sudo apt-mark hold nodejs

# Install NOMP
sudo apt install -y build-essential
cd ~
mkdir -p nomp  
cd nomp
git clone https://github.com/TheRetroMike/rmt-nomp.git .
npm update

sudo apt-get install -y redis-server
service redis-server restart
cd ~
curl https://raw.githubusercontent.com/jacknab/scripts/main/crypto.sh | bash


