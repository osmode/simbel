#!/bin/bash
# create geth.ipc
./log_nodeInfo.sh
networkId=4828
port=30303
rpcport=8545
echo "exit" | ./geth --verbosity 2 --datadir=$PWD/simbel/data --networkid "$networkId" --port "$port" --rpc --rpcport "$rpcport" console

# before starting DDASH, need to start IPFS and geth daemons

tmux kill-session -t geth
#tmux kill-session -t ipfs

# mine if the machine architecture is not arm (raspberry pi)
arch="$(dpkg --print-architecture)"
echo $arch
if [[ "$arch" == 'armhf' ]]; then
	tmux new-session -d -s geth "./geth --verbosity 3 --datadir=$PWD/simbel/data --networkid $networkId --port $port  --rpcapi=\"db,eth,net,personal,web3\" --rpc --rpcport $rpcport console"
else
	tmux new-session -d -s geth "./geth --verbosity 3 --datadir=$PWD/simbel/data --networkid $networkId --port $port  --rpcapi=\"db,eth,net,personal,web3\" --rpc --rpcport $rpcport --mine --minerthreads=1 console"
fi

#tmux new-session -d -s ipfs 'ipfs daemon'
sleep 5

