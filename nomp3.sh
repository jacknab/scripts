#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
#
#########################################################
set -x
sudo DEBIAN_FRONTEND=noninteractive apt remove -y nodejs npm
# sudo apt remove -y nodejs npm
sudo DEBIAN_FRONTEND=noninteractive apt purge -y nodejs npm
# sudo apt purge -y nodejs npm
sudo apt autoremove
sudo rm -rf /usr/local/node-v0.10.48
sudo rm /usr/bin/node
sudo rm /usr/bin/npm

wget -4 https://nodejs.org/dist/v0.10.48/node-v0.10.48-linux-x64.tar.gz
tar -xzf node-v0.10.48-linux-x64.tar.gz
sudo mv node-v0.10.48-linux-x64 /usr/local/node-v0.10.48
sudo ln -s /usr/local/node-v0.10.48/bin/node /usr/bin/node
sudo ln -s /usr/local/node-v0.10.48/bin/npm /usr/bin/npm

# Install Nodejs
# curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
# sudo apt install -y nodejs
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# source ~/.bashrc

# Install NOMP
# sudo apt install -y build-essential
# cd ~
# mkdir nomp
# cd nomp
# git clone https://github.com/nomp/node-open-mining-portal.git .
# nvm install 16
# nvm use 16
# npm rebuild --force
# npm update

# sudo apt-get install -y redis-server
# service redis-server restart
# cd ~
curl -s https://raw.githubusercontent.com/jacknab/scripts/main/nomp_patch.sh | bash


