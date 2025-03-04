#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/mundoteam.sh | bash
#
#########################################################
sudo apt-get update
sudo apt-get install libfmt-dev

git clone https://github.com/jacknab/MundoTeam_Core.git
cd MundoTeam_Core
chmod +x autogen.sh
cd share
chmod +x genbuild.sh
cd ..
./autogen.sh
./configure --with-incompatible-bdb
make
make install
cd src
./mundoteamd -daemon
./mundoteam-cli createwallet default
./mundoteam-cli getnewaddress legacy > /MundoTeam_walletaddress_legacy.txt
./mundoteam-cli getnewaddress > /MundoTeam_walletaddress.txt
