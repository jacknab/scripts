#!/usr/bin/env bash

#########################################################
# Created by jacknab for php-mpos and nomp pool...
# This script is intended to be run on Debian 11
# like this:
# curl https://raw.githubusercontent.com/jacknab/scripts/main/install.sh | bash
#
#########################################################


# Install Basic Build Tools
sudo apt update
sudo apt install -y build-essential autoconf libtool pkg-config curl g++ make automake

# Install Common Dependencies for Cryptocurrency Cores
sudo apt install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev
sudo apt install -y libboost-program-options-dev libboost-test-dev libboost-thread-dev
sudo apt install -y libssl-dev libevent-dev bsdmainutils libzmq3-dev
sudo apt install -y libminiupnpc-dev libprotobuf-dev protobuf-compiler
sudo apt install -y libqrencode-dev libdb-dev libdb++-dev
sudo apt install -y cmake build-essential
sudo apt install libfmt-dev

# Remove existing Berkeley DB versions
sudo apt remove libdb-dev libdb++-dev -y

# Download and install Berkeley DB 4.8:
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
tar -xvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix
../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/usr/local
make
sudo make install

Ensure the compiler knows about the Berkeley DB path:
export BDB_INCLUDE_PATH="/usr/local/include"
export BDB_LIB_PATH="/usr/local/lib"

# Install Other Libraries (for GUI)
sudo apt -y install qtbase5-dev qttools5-dev-tools libqrencode-dev qttools5-dev libprotobuf-dev
cd ~
curl -S https://raw.githubusercontent.com/jacknab/scripts/main/mundoteam.sh | bash
