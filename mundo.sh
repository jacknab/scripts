#!/usr/bin/env bash
#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
#
#########################################################

sudo apt-get update
sudo apt-get install build-essential libtool autoconf automake pkg-config libssl-dev libboost-all-dev libdb++-dev libminiupnpc-dev libgmp-dev
sudo apt-get install libseccomp-dev
sudo apt-get update
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libboost-all-dev libevent-dev
sudo apt-get install libminiupnpc-dev libgmp-dev libseccomp-dev libcap-dev
pkg-config --modversion libseccomp
sudo apt-get install libcap-dev
sudo apt-get install g++-mingw-w64-i686 mingw-w64-i686-dev g++-mingw-w64-x86-64 mingw-w64-x86-64-dev curl libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
sudo apt-get install g++-arm-linux-gnueabihf curl

git clone https://github.com/jacknab/MundoTeam_Core.git
cd /root/MundoTeam_Core
cd depends
make HOST=arm-linux-gnueabihf NO_QT=1
cd ..
./autogen.sh
./configure --prefix=$PWD/depends/arm-linux-gnueabihf --enable-glibc-back-compat --enable-reduce-exports LDFLAGS=-static-libstdc++
make
