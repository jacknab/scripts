#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
#
#########################################################

# Install Nodejs
curl -fsSL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt install -y nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install 14.13.1
nvm alias default 14.13.1

# Install NOMP
sudo apt install -y build-essential
wget https://raw.githubusercontent.com/jacknab/scripts/main/nomp_.tar.gz
tar -xvzf nomp_.tar.gz
sudo apt-get install -y redis-server
service redis-server restart

# curl -s https://raw.githubusercontent.com/jacknab/scripts/main/nomp_patch.sh | bash


