#!/bin/bash
# create geth.ipc
./log_nodeInfo.sh
port=30303
rpcport=8545

# check OS
os="$(uname -s)"
# if Mac OS X
if [ "$os" = 'Darwin' ]; then

# Create IPC file
echo "exit" | geth --verbosity 2 --datadir=$PWD/simbel/data_mainnet console
sleep 1
tmux new-session -d -s geth "geth --verbosity 3 --datadir=$PWD/simbel/data_mainnet console"
sleep 5
exit

else
arch="$(dpkg  --print-architecture)"
fi

# if Raspberry Pi
if [[ "$arch" == 'armhf' ]]; then
	echo -e "\033[0;31mIt appears you're installing Simbel on a Raspberry Pi!  :)"

	echo "exit" | ./geth --verbosity 2 --datadir=$PWD/simbel/data_mainnet console

	tmux new-session -d -s geth "./geth --verbosity 3 --fast --cache=1024 --datadir=$PWD/simbel/data_mainnet console"

# if Linux but not Raspberry Pi
else
# create IPC file
echo "exit" | geth --verbosity 2 --datadir=$PWD/simbel/data_mainnet console

fi

sleep 5
tmux new-session -d -s geth "geth --verbosity 3 --fast --cache=1024 --datadir=$PWD/simbel/data_mainnet console"


