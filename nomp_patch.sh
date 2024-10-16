#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
# This is for scrypt algo for NOMP
#########################################################
set -x
cd /root/node-open-mining-portal/libs
sudo rm profitSwitch.js
wget http://raw.githubusercontent.com/jacknab/scripts/main/profitSwitch.js
cd /root/node-open-mining-portal/node_modules/stratum-pool/lib
sudo rm pool.js
wget http://raw.githubusercontent.com/jacknab/scripts/main/pool.js
cd ~
echo "Replacements completed successfully!"




