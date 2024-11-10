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

# Install pip2
echo "Installing pip2..."
wget -4 https://bootstrap.pypa.io/pip/2.7/get-pip.py
python2 get-pip.py

# Remove existing litecoin directory if it exists
if [ -d "litecoin" ]; then
    echo "Removing existing Hugocoin directory..."
    rm -rf litecoin
fi

# Clone the Hugocoin repository (using the 0.18 branch)
echo "Cloning Hugocoin repository..."
git clone -b 0.18 http://github.com/litecoin-project/litecoin.git
cd litecoin || exit

# Make autogen.sh and genbuild.sh executable
echo "Setting execute permissions on autogen.sh and genbuild.sh..."
chmod +x autogen.sh share/genbuild.sh

# Download and run genesis.py
echo "Downloading genesis.py..."
wget -4 https://raw.githubusercontent.com/lhartikk/GenesisH0/master/genesis.py
chmod +x genesis.py

# Generate genesis block hash and Merkle root
echo "Generating genesis block hash and Merkle root..."
pip install scrypt==0.8.6
pip2 install scrypt construct==2.5.2
GENESIS_OUTPUT=$(python2 genesis.py -a scrypt -z "CNN 08/11/2024 Donald Trump become president again" -p "040184710fa689ad5023690c80f3a49c8f13f8d45b8c857fbcbc8bc4a8e4d3eb4b10f4d4604fa08dce601aaf0f470216fe1b51850b4acf21b179c45070ac7b03a9" -t 1317972665 -n $NONCE)

# Extract the genesis hash and merkle root from the output
GENESIS_HASH=$(echo "$GENESIS_OUTPUT" | grep "Genesis Block Hash:" | awk '{print $NF}')
MERKLE_ROOT=$(echo "$GENESIS_OUTPUT" | grep "Merkle Root:" | awk '{print $NF}')

# Modify src/chainparams.cpp
echo "Modifying src/chainparams.cpp..."
sed -i "s/strNetworkID = \"test\";/strNetworkID = \"hugocoin\";/g" src/chainparams.cpp
sed -i "s/The Times 05\/Nov\/2024 Trump becomes President again/$COIN_NAME Timestamp Here/g" src/chainparams.cpp
sed -i "s/genesis.nTime = 1231006505;/genesis.nTime = $TIMESTAMP;/g" src/chainparams.cpp
sed -i "s/genesis.nNonce = 2083236893;/genesis.nNonce = $NONCE;/g" src/chainparams.cpp
sed -i "s/genesis.nBits = 0x1d00ffff;/genesis.nBits = 0x1e0fffff;/g" src/chainparams.cpp
sed -i "s/pchMessageStart\[0\] = 0x4c;/pchMessageStart\[0\] = 0x42;/g" src/chainparams.cpp
sed -i "s/pchMessageStart\[0\] = 0x4c;/pchMessageStart\[0\] = 0x68;/g" src/chainparams.cpp  # Update for H
sed -i "s/static MapCheckpoints checkpoints = {/static MapCheckpoints checkpoints = {\n    { 0, uint256(\"$GENESIS_HASH\") }/g" src/validation.cpp

# Set block reward to 2000 and disable halving
echo "Setting block reward to 2000 and disabling halving..."
sed -i "s/consensus.nSubsidy = .*;/consensus.nSubsidy = 2000 * COIN;/g" src/chainparams.cpp
sed -i "s/consensus.nHalvingInterval = .*;/consensus.nHalvingInterval = 999999999;/g" src/chainparams.cpp  # Set a very high number to prevent halving

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

# Change default port to 4666
echo "Changing default port to 4666..."
find ./ -type f -readable -writable -exec sed -i "s/9333/9666/g" {} \;

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
