#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
#
#########################################################

# Install NOMP
sudo apt install -y build-essential
cd ~
mkdir -p nomp  
cd nomp
git clone https://github.com/zone117x/node-open-mining-portal.git .
npm update
cd ~
curl https://raw.githubusercontent.com/jacknab/scripts/main/crypto.sh | bash


