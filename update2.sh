#!/bin/bash

# File 1: ~/nomp/libs/profitSwitch.js
# Replace line 545
sed -i '545s|.*|daemon.cmd('\'\'getblocktemplate'\'', [{"capabilities": [ "coinbasetxn", "workid", "coinbase/append" ], "rules": [ "mweb", "segwit" ]}], function(result) {|' ~/node-open-mining-portal/libs/profitSwitch.js

# File 2: ~/nomp/node_modules/stratum-pool/lib/pool.js
# Replace line 122
sed -i '122s|.*|_this.daemon.cmd('\'\'getblocktemplate'\'', [{"capabilities": [ "coinbasetxn", "workid", "coinbase/append" ], "rules": [ "mweb", "segwit" ]}], function(results){|' ~/node-open-mining-portal/node_modules/stratum-pool/lib/pool.js

# Replace line 580
sed -i '580s|.*|[{"capabilities": [ "coinbasetxn", "workid", "coinbase/append" ], "rules": [ "mweb", "segwit" ]}],|' ~/nomp/node_modules/stratum-pool/lib/pool.js

echo "Replacements completed successfully!"

