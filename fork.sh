#!/usr/bin/env bash

sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
sudo apt-get install libminiupnpc-dev
sudo apt-get install libzmq3-dev

sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install libdb4.8-dev libdb4.8++-dev

git clone https://github.com/litecoin-project/litecoin.git




find ./ -type f -readable -writable -exec sed -i "s/Hugocoin/Hugocoin/g" {} \;
find ./ -type f -readable -writable -exec sed -i "s/HugoCoin/HugoCoin/g" {} \;
find ./ -type f -readable -writable -exec sed -i "s/HUGO/HUGO/g" {} \;
find ./ -type f -readable -writable -exec sed -i "s/hugocoin/hugocoin/g" {} \;
find ./ -type f -readable -writable -exec sed -i "s/hugocoind/hugocoind/g" {} \;


find ./ -type f -readable -writable -exec sed -i "s/lites/HUGO/g" {} \;
find ./ -type f -readable -writable -exec sed -i "s/photons/HUGO/g" {} \;



find ./ -type f -readable -writable -exec sed -i "s/9333/9666/g" {} \;  // change default port




cd ${lite-coin-fork}
nano src/chainparams.cpp
    consensus.nSubsidyHalvingInterval = 11; //maximum coin supply
    
    
    pchMessageStart[0] = 0xd0;
    pchMessageStart[1] = 0xe1;
    pchMessageStart[2] = 0xf5;
    pchMessageStart[3] = 0xec;
    
    
    base58Prefixes[PUBKEY_ADDRESS] = std::vector<unsigned char>(1,35);

    base58Prefixes[SECRET_KEY] = std::vector<unsigned char>(1,35);

    base58Prefixes[EXT_PUBLIC_KEY] = {0xff, 0x88, 0xB2, 0x1E};

    base58Prefixes[EXT_SECRET_KEY] = {0xff, 0x88, 0xAD, 0xE4};
    
    //comment out  checkpointData block
       
    
nano src/validation.cpp
      CAmount GetBlockSubsidy(int nHeight, const Consensus::Params& consensusParams)
    {
      int halvings = nHeight / consensusParams.nSubsidyHalvingInterval;
    // Force block reward to zero when right shift is undefined.
    if (halvings >= 64)
        return 0;

    CAmount nSubsidy = 100 * COIN;
    // Subsidy is cut in half every 210,000 blocks which will occur approximate$

    if(nHeight < 11)
    {
        nSubsidy = 100000 * COIN;
    }

    //nSubsidy >>= halvings;
    return nSubsidy;

    }


nano src/amount.h

    static const CAmount COIN = 100000000;   // coin value
    static const CAmount CENT = 1000000;      // how far coin can be splited
    static const CAmount MAX_MONEY = 84000000 * COIN;   // total number of coin
    
    
git clone  https://github.com/lhartikk/GenesisH0
cd GenesisH0
python genesis.py -a scrypt -z "BBC NEWS 20/Dec/2017 Bitcoin Cash deals frozen as insider trading is probed" -p "040184710fa689ad5023690c80f3a49c8f13f8d45b8c857fbcbc8bc4a8e4d3eb4b10f4d4604fa08dce601aaf0f470216fe1b51850b4acf21b179c45070ac7b03a9" -t 1513784917 -n 2084524493

//change 12 word for your convence


cd ${litcoin-fork-root}

./autogen.sh
./configure  --without-gui  //use without-gui parameter to exclude qt stuff


make   // wait for upto an hour if you are getting error on doc/man

make install

cd src
strip hugocoind
cd $HOME

hugocoind

cd .hugocoin

nano .hugocoin.conf
    server=1
    rpcuser=user
    rpcpassword=password
    
cd ${litcoin-fork-root}


chmod 0600 hugocoin.conf


// depoly second instance do same procedures, change in .hugocoin.conf

  addnode=ip-address-of-other-node:port-no   // add n number of addnode to connect to network
  listen=1
  
  hugocoind  -deprecatedrpc=accounts // run 


hugocoin-cli getblockchaininfo 

nano generate.sh

#!/bin/bash
echo "Mining... Press [CTRL+C] to stop"
while :
do
  tetherwin-cli generate 1
done

 chmod +x generate.sh
 
 ./generate.sh
