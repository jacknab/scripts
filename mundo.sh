#!/usr/bin/env bash
set -x
sudo apt-get update -y
sudo apt-get -y install build-essential libtool autoconf automake pkg-config libssl-dev libboost-all-dev libdb++-dev libminiupnpc-dev libgmp-dev
sudo apt-get -y install libseccomp-dev
sudo apt-get update -y
sudo apt-get -y install build-essential libtool autotools-dev automake pkg-config libssl-dev libboost-all-dev libevent-dev
sudo apt-get -y install libminiupnpc-dev libgmp-dev libseccomp-dev libcap-dev
pkg-config --modversion libseccomp
sudo apt-get -y install libcap-dev
sudo apt-get -y install g++-mingw-w64-i686 mingw-w64-i686-dev g++-mingw-w64-x86-64 mingw-w64-x86-64-dev curl libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
sudo apt-get -y install g++-arm-linux-gnueabihf curl

git clone https://github.com/jacknab/MundoTeam_Core.git
cd /root/MundoTeam_Core
cd depends
make HOST=arm-linux-gnueabihf NO_QT=1
cd ..
./autogen.sh
./configure --prefix=$PWD/depends/arm-linux-gnueabihf --enable-glibc-back-compat --enable-reduce-exports LDFLAGS=-static-libstdc++
make
