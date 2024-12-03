#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
#
#########################################################
exec > Nodejs-Nomp.txt 2>&1

# Install Nodejs
wget https://nodejs.org/dist/v10.19.0/node-v10.19.0-linux-x64.tar.xz
tar -xf node-v10.19.0-linux-x64.tar.xz
sudo mv node-v10.19.0-linux-x64 /usr/local/node-10.19.0
sudo ln -s /usr/local/node-10.19.0/bin/node /usr/local/bin/node
sudo ln -s /usr/local/node-10.19.0/bin/npm /usr/local/bin/npm
sudo npm install -g npm@latest
sudo apt-get autoremove
sudo apt-get clean

#sudo apt install -y nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
#nvm install 10.19.0
#nvm alias default 10.19.0

# Install NOMP
sudo apt install -y build-essential
wget https://raw.githubusercontent.com/jacknab/scripts/main/nomp_.tar.gz
tar -xvzf nomp_.tar.gz
sudo apt-get install -y redis-server
service redis-server restart

# curl -s https://raw.githubusercontent.com/jacknab/scripts/main/nomp_patch.sh | bash


