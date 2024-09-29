#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
#
#########################################################

# File 1: /root/nomp/libs/profitSwitch.js
# Replace line 545
sed -i '545s|.*|daemon.cmd('\'\'getblocktemplate'\'', [{"capabilities": [ "coinbasetxn", "workid", "coinbase/append" ], "rules": [ "mweb", "segwit" ]}], function(result) {|' /root/nomp/libs/profitSwitch.js

# File 2: /root/nomp/node_modules/stratum-pool/lib/pool.js
# Replace line 122
sed -i '122s|.*|_this.daemon.cmd('\'\'getblocktemplate'\'', [{"capabilities": [ "coinbasetxn", "workid", "coinbase/append" ], "rules": [ "mweb", "segwit" ]}], function(results){|' /root/nomp/node_modules/stratum-pool/lib/pool.js

# Replace line 580
sed -i '580s|.*|[{"capabilities": [ "coinbasetxn", "workid", "coinbase/append" ], "rules": [ "mweb", "segwit" ]}],|' /root/nomp/node_modules/stratum-pool/lib/pool.js

echo "Replacements completed successfully!"
cd ~
bash /scripts/update_mpos_config.sh

