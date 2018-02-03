#!/bin/bash
# create geth.ipc
./log_nodeInfo.sh
networkId=4828
port=30303
rpcport=8545

arch="$(dpkg  --print-architecture)"
if [[ "$arch" == 'armhf' ]]; then
	echo -e "\033[0;31mIt appears you're installing Simbel on a Raspberry Pi!  :)"

echo "exit" | ./geth --verbosity 2 --datadir=$PWD/simbel/data_mainnet console

# before starting DDASH, need to start IPFS and geth daemons

tmux kill-session -t geth
#tmux kill-session -t ipfs

tmux new-session -d -s geth ./geth --verbosity 3 --fast --cache=1024 --datadir=$PWD/simbel/data_mainnet console"


else

echo "exit" | geth --verbosity 2 --datadir=$PWD/simbel/data_mainnet console

# before starting DDASH, need to start IPFS and geth daemons

tmux kill-session -t geth
#tmux kill-session -t ipfs

tmux new-session -d -s geth geth --verbosity 3 --fast --cache=1024 --datadir=$PWD/simbel/data_mainnet console"

#tmux new-session -d -s ipfs 'ipfs daemon'
fi

sleep 8

#python3 $PWD/simbel/main.py


