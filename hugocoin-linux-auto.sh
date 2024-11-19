#!/bin/bash

sudo apt-get update && sudo apt-get upgrade -y

cd $HOME

wget -4 "https://dl.walletbuilders.com/download?customer=eb30c51e632df38e03c4d499f0d39a5a036cb3a368462f7183&filename=hugocoin-qt-linux.tar.gz" -O hugocoin-qt-linux.tar.gz

mkdir $HOME/Desktop/Hugocoin0

tar -xzvf hugocoin-qt-linux.tar.gz --directory $HOME/Desktop/Hugocoin0

mkdir $HOME/.hugocoin

cat << EOF > $HOME/.hugocoin/hugocoin.conf
rpcuser=rpc_hugocoin
rpcpassword=dR2oBQ3K1zYMZQtJFZeAerhWxaJ5Lqeq9J2
rpcbind=127.0.0.1
rpcallowip=127.0.0.1
listen=1
server=1
addnode=node3.walletbuilders.com
EOF

cat << EOF > $HOME/Desktop/Hugocoin0/start_wallet.sh
#!/bin/bash
SCRIPT_PATH=\`pwd\`;
cd \$SCRIPT_PATH
./hugocoin-qt
EOF

chmod +x $HOME/Desktop/Hugocoin0/start_wallet.sh

cat << EOF > $HOME/Desktop/Hugocoin0/mine.sh
#!/bin/bash
SCRIPT_PATH=\`pwd\`;
cd \$SCRIPT_PATH
while :
do
./hugocoin-cli generatetoaddress 1 \$(./hugocoin-cli getnewaddress)
done
EOF

chmod +x $HOME/Desktop/Hugocoin0/mine.sh
    
exec $HOME/Desktop/Hugocoin0/hugocoin-qt &

sleep 15

exec $HOME/Desktop/Hugocoin0/hugocoin-cli -named createwallet wallet_name="" &
    
sleep 15

cd $HOME/Desktop/Hugocoin0/

clear

exec $HOME/Desktop/Hugocoin0/mine.sh
