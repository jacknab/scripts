#!/bin/bash

# Exit script on error
set -e

# Variables
REPO_URL="https://github.com/litecoin-project/litecoin.git"
COIN_NAME="Hugocoin"
TICKER="HUGO"
TIMESTAMP=$(date +%s)  # Get current timestamp
NONCE="1"          # Update to your desired nonce
WALLET_ADDRESS_PREFIX="h"  # First letter of the wallet address
FRAC_NAME="HUGO"        # Name for fractions of the coin
PORT_BASE=20096         # Base port number for the coin
P2P_PORT=$((PORT_BASE + 1))  # P2P port
RPC_PORT=$((PORT_BASE + 2))  # RPC port

# Remove existing litecoin directory if it exists
if [ -d "litecoin" ]; then
    echo "Removing existing coin directory..."
    rm -rf litecoin
fi

# Clone the Litecoin repository (using the 0.18 branch)
echo "Cloning Litecoin repository..."
git clone -b 0.21 http://github.com/litecoin-project/litecoin.git
cd litecoin || exit

# Make autogen.sh and genbuild.sh executable
echo "Setting execute permissions on autogen.sh and genbuild.sh..."
chmod +x autogen.sh share/genbuild.sh

# Download and run genesis.py
echo "Downloading genesis.py..."
wget https://raw.githubusercontent.com/lhartikk/GenesisH0/master/genesis.py
chmod +x genesis.py

# Generate genesis block hash and Merkle root
echo "Generating genesis block hash and Merkle root..."
GENESIS_OUTPUT=$(python2 genesis.py -a scrypt -z "OneCent was created on Nov 26 2024" -p "040184710fa689ad5023690c80f3a49c8f13f8d45b8c857fbcbc8bc4a8e4d3eb4b10f4d4604fa08dce601aaf0f470216fe1b51850b4acf21b179c45070ac7b03a9" -t $TIMESTAMP -n $NONCE)

# Extract the genesis hash and merkle root from the output
GENESIS_HASH=$(echo "$GENESIS_OUTPUT" | grep "Genesis Block Hash:" | awk '{print $NF}')
MERKLE_ROOT=$(echo "$GENESIS_OUTPUT" | grep "Merkle Root:" | awk '{print $NF}')

# Modify src/chainparams.cpp
echo "Modifying src/chainparams.cpp..."
sed -i "s/strNetworkID = \"test\";/strNetworkID = \"hugocoin\";/g" src/chainparams.cpp
sed -i "s/OneCent was created on Nov 20 2024/$COIN_NAME Timestamp Here/g" src/chainparams.cpp
sed -i "s/genesis.nTime = 1231006505;/genesis.nTime = $TIMESTAMP;/g" src/chainparams.cpp
sed -i "s/genesis.nNonce = 2083236893;/genesis.nNonce = $NONCE;/g" src/chainparams.cpp
sed -i "s/genesis.nBits = 0x1d00ffff;/genesis.nBits = 0x1e0fffff;/g" src/chainparams.cpp
sed -i "s/pchMessageStart\[0\] = 0x4c;/pchMessageStart\[0\] = 0x42;/g" src/chainparams.cpp
sed -i "s/pchMessageStart\[0\] = 0x4c;/pchMessageStart\[0\] = 0x68;/g" src/chainparams.cpp  # Update for H
sed -i "s/static MapCheckpoints checkpoints = {/static MapCheckpoints checkpoints = {\n    { 0, uint256(\"$GENESIS_HASH\") }/g" src/validation.cpp

# Set block reward to 200 and disable halving
echo "Setting block reward to 200 and disabling halving..."
sed -i "s/consensus.nSubsidy = .*;/consensus.nSubsidy = 200 * COIN;/g" src/chainparams.cpp
sed -i "s/consensus.nHalvingInterval = .*;/consensus.nHalvingInterval = 999999999;/g" src/chainparams.cpp  # Set a very high number to prevent halving

# Modify src/chainparams.h
echo "Modifying src/chainparams.h..."
sed -i "s/static const std::string strNetworkID = \"test\";/static const std::string strNetworkID = \"hugocoin\";/g" src/chainparams.h
sed -i "s/static const std::string COIN_NAME = \"Hugocoin\";/static const std::string COIN_NAME = \"$COIN_NAME\";/g" src/chainparams.h
sed -i "s/static const std::string FRAC_NAME = \"Lites\";/static const std::string FRAC_NAME = \"$FRAC_NAME\";/g" src/chainparams.h

# Replace seed addresses
echo "Replacing seed addresses in src/chainparams.cpp..."
sed -i "s|vSeeds.emplace_back(\".*\");|vSeeds.emplace_back(\"node.hugocoin.net\");\nvSeeds.emplace_back(\"node.poolets.com\");|g" src/chainparams.cpp

# Set minimum chain work to 0x00
echo "Setting minimum chain work to 0x00..."
sed -i "s/consensus.nMinimumChainWork = .*;/consensus.nMinimumChainWork = uint256S(\"0x00\");/g" src/chainparams.cpp

# Change default port to 4666
echo "Changing default port to 20095..."
find ./ -type f -readable -writable -exec sed -i "s/9333/20095/g" {} \;

PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g')
cd depends
make HOST=x86_64-pc-linux-gnu
cd ..

# Run autogen and configure scripts
echo "Running autogen.sh..."
./autogen.sh
CONFIG_SITE=$PWD/depends/x86_64-pc-linux-gnu/share/config.site ./configure --prefix=/
make
make clean
PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g')
cd depends
make HOST=i686-pc-linux-gnu
cd ..
# Compile the code
echo "Compiling the code..."
./autogen.sh
CONFIG_SITE=$PWD/depends/i686-pc-linux-gnu/share/config.site ./configure --prefix=/
make

# Rename the directory to Hugocoin
echo "Renaming directory to Hugocoin..."
cd .. 
mv litecoin hugocoin

echo "$COIN_NAME has been created with the ticker $TICKER!"
echo "Current timestamp: $TIMESTAMP"
echo "Nonce value: $NONCE"
echo "P2P Port: $P2P_PORT"
echo "RPC Port: $RPC_PORT"
