#!/bin/bash

# Exit script on error
set -e

# Variables
REPO_URL="https://github.com/litecoin-project/litecoin.git"
COIN_NAME="Hugocoin"
TICKER="HUGO"
TIMESTAMP=$(date +%s)  # Get current timestamp
NONCE="123456"          # Update to your desired nonce
WALLET_ADDRESS_PREFIX="h"  # First letter of the wallet address
FRAC_NAME="HUGO"        # Name for fractions of the coin
PORT_BASE=20100         # Base port number for the coin
P2P_PORT=$((PORT_BASE + 1))  # P2P port
RPC_PORT=$((PORT_BASE + 2))  # RPC port

# Check and install dependencies
echo "Installing required dependencies..."
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    libtool \
    autotools-dev \
    automake \
    pkg-config \
    libssl-dev \
    libboost-all-dev \
    libevent-dev \
    libminiupnpc-dev \
    libzmq3-dev \
    qtbase5-dev \
    qtchooser \
    qt5-qmake \
    qtbase5-dev-tools \
    libprotobuf-dev \
    protobuf-compiler \
    python2 \
    python2-dev \
    python-setuptools

# Remove existing litecoin directory if it exists
if [ -d "litecoin" ]; then
    echo "Removing existing Hugocoin directory..."
    rm -rf litecoin
fi

# Clone the litecoin repository (using the 0.21 branch)
echo "Cloning litecoin repository..."
git clone -b 0.21 http://github.com/litecoin-project/litecoin.git
# cd litecoin || exit


# Generate genesis block hash and Merkle root
echo "Generating genesis block hash and Merkle root..."
GENESIS_OUTPUT=$(python2 genesis.py -a scrypt -z "This coin was created in 2024" -p "040184710fa689ad5023690c80f3a49c8f13f8d45b8c857fbcbc8bc4a8e4d3eb4b10f4d4604fa08dce601aaf0f470216fe1b51850b4acf21b179c45070ac7b03a9" -t 1317972665 -n $NONCE)

# Extract the genesis hash and merkle root from the output
GENESIS_HASH=$(echo "$GENESIS_OUTPUT" | grep "Genesis Block Hash:" | awk '{print $NF}')
MERKLE_ROOT=$(echo "$GENESIS_OUTPUT" | grep "Merkle Root:" | awk '{print $NF}')

# Modify src/chainparams.cpp
echo "Modifying src/chainparams.cpp..."
sed -i "s/strNetworkID = \"test\";/strNetworkID = \"hugocoin\";/g" src/chainparams.cpp
sed -i "s/This coin was created in 2024/$COIN_NAME Timestamp Here/g" src/chainparams.cpp
sed -i "s/genesis.nTime = 1231006505;/genesis.nTime = $TIMESTAMP;/g" src/chainparams.cpp
sed -i "s/genesis.nNonce = 2083236893;/genesis.nNonce = $NONCE;/g" src/chainparams.cpp
sed -i "s/genesis.nBits = 0x1d00ffff;/genesis.nBits = 0x1e0fffff;/g" src/chainparams.cpp
sed -i "s/pchMessageStart\[0\] = 0x4c;/pchMessageStart\[0\] = 0x42;/g" src/chainparams.cpp
sed -i "s/pchMessageStart\[0\] = 0x4c;/pchMessageStart\[0\] = 0x68;/g" src/chainparams.cpp  # Update for H
sed -i "s/static MapCheckpoints checkpoints = {/static MapCheckpoints checkpoints = {\n    { 0, uint256(\"$GENESIS_HASH\") }/g" src/validation.cpp

# Set block reward to 100 and 
echo "Setting block reward to 100 and 4 year halving..."
sed -i "s/consensus.nSubsidy = .*;/consensus.nSubsidy = 100 * COIN;/g" src/chainparams.cpp
sed -i "s/consensus.nHalvingInterval = .*;/consensus.nHalvingInterval = 840960;/g" src/chainparams.cpp 

# Modify src/chainparams.h
echo "Modifying src/chainparams.h..."
sed -i "s/static const std::string strNetworkID = \"test\";/static const std::string strNetworkID = \"hugocoin\";/g" src/chainparams.h
sed -i "s/static const std::string COIN_NAME = \"Hugocoin\";/static const std::string COIN_NAME = \"$COIN_NAME\";/g" src/chainparams.h
sed -i "s/static const std::string FRAC_NAME = \"Lites\";/static const std::string FRAC_NAME = \"$FRAC_NAME\";/g" src/chainparams.h

# Remove DNS seeds and seed nodes
echo "Removing DNS seeds and seed nodes..."
sed -i '/vSeeds.emplace_back/d' src/chainparams.cpp
# Commenting out the removal of pnSeed6_main to prevent build errors
# sed -i '/pnSeed6_main/d' src/chainparamsseeds.h  

# Set minimum chain work to 0x00
echo "Setting minimum chain work to 0x00..."
sed -i "s/consensus.nMinimumChainWork = .*;/consensus.nMinimumChainWork = uint256S(\"0x00\");/g" src/chainparams.cpp

# Change default port to 20085
echo "Changing default port to 20085..."
find ./ -type f -readable -writable -exec sed -i "s/9333/20085/g" {} \;

# Run autogen and configure scripts
echo "Running autogen.sh..."
./autogen.sh

echo "Configuring build..."
./configure --with-incompatible-bdb

# Compile the code
echo "Compiling the code..."
make -j$(nproc)  # Compile using all available CPU cores

# Rename the directory to Hugocoin
echo "Renaming directory to Hugocoin..."
cd .. 
mv litecoin hugocoin

echo "$COIN_NAME has been created with the ticker $TICKER!"
echo "Current timestamp: $TIMESTAMP"
echo "Nonce value: $NONCE"
echo "P2P Port: $P2P_PORT"
echo "RPC Port: $RPC_PORT"
