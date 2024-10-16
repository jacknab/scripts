#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
# This is for scrypt algo for NOMP
#########################################################
set -x
sudo rm /root/node-open-mining-portal/node_modules/stratum-pool/lib/pool.js
sudo rm /root/node-open-mining-portal/libs/profitSwitch.js
sudo rm /root/nomp/node_modules/stratum-pool/lib/pool.js
sudo rm /root/nomp/libs/profitSwitch.js

git clone https://github.com/jacknab/nomp-patch.git .
sudo cp profitSwitch.js /root/node-open-mining-portal/libs/
sudo cp profitSwitch.js /root/nomp/libs/
rm profitSwitch.js
sudo cp pool.js /root/node-open-mining-portal/node_modules/stratum-pool/lib
sudo cp pool.js /root/nomp/node_modules/stratum-pool/lib
sudo rm pool.js
cd ~
echo "Replacements completed successfully!"




