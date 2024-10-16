#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
# This is for scrypt algo for NOMP
#########################################################
set -x
cd /root/nomp/libs
sudo rm profitSwitch.js
wget -4 https://raw.githubusercontent.com/jacknab/scripts/main/profitSwitch.js
cd /root/nomp/node_modules/stratum-pool/lib
sudo rm pool.js
wget -4 https://raw.githubusercontent.com/jacknab/scripts/main/pool.js
cd ~
echo "Replacements completed successfully!"




