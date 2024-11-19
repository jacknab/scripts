#!/bin/bash

sudo apt-get update && sudo apt-get upgrade -y

cd $HOME

wget "https://dl.walletbuilders.com/download?customer=45c4ee58b28ad935f1e43c20dd9f827a043e31f12a283d5b4d&filename=hugocoin-qt-linux.tar.gz" -O hugocoin-qt-linux.tar.gz

mkdir $HOME/Desktop/Hugocoin

tar -xzvf hugocoin-qt-linux.tar.gz --directory $HOME/Desktop/Hugocoin

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

cat << EOF > $HOME/Desktop/Hugocoin/start_wallet.sh
#!/bin/bash
SCRIPT_PATH=\`pwd\`;
cd \$SCRIPT_PATH
./hugocoin-qt
EOF

chmod +x $HOME/Desktop/Hugocoin/start_wallet.sh

cat << EOF > $HOME/Desktop/Hugocoin/mine.sh
#!/bin/bash
SCRIPT_PATH=\`pwd\`;
cd \$SCRIPT_PATH
while :
do
./hugocoin-cli generatetoaddress 1 \$(./hugocoin-cli getnewaddress)
done
EOF

chmod +x $HOME/Desktop/Hugocoin/mine.sh
    
exec $HOME/Desktop/Hugocoin/hugocoin-qt &

sleep 15

exec $HOME/Desktop/Hugocoin/hugocoin-cli -named createwallet wallet_name="" &
    
sleep 15

cd $HOME/Desktop/Hugocoin/

clear

exec $HOME/Desktop/Hugocoin/mine.sh
