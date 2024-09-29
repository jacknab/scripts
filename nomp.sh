#!/usr/bin/env bash

# Install NOMP
sudo apt install -y build-essential
cd
mkdir -p nomp  
cd nomp
git clone https://github.com/zone117x/node-open-mining-portal.git .
npm update
