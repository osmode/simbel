#!/bin/bash
arch="$(dpkg  --print-architecture)"
finished=false

if [ ! $finished = false ]; then
    echo finished is false
fi

while [ $finished = false ]
do

LIGHT_CYAN='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # NO COLOR

echo -e "
${LIGHT_CYAN}Welcome to the Simbel Network Utility. What would you like to do?${NC}
${GREEN}1: Create new Ethereum account 
2: Show existing Ethereum accounts ${NC}
3: Start mining
4: Compile contract
${RED}5: Start Simbel ${NC}  
6: Show network settings
7: Add peer
8: Launch private network
9: Exit
" 

read -p "
> " choice

    if [ "$choice" = 1 ]; then
	tmux kill-session -t geth
	#tmux kill-session -t ipfs

	read -sp "Choose a password: " pass        
	if [[ "$arch" == 'armhf' ]]; then
		echo "personal.newAccount(\"$pass\")" | ./geth --verbosity 1 --datadir=$PWD/simbel/data console 
	else
		echo "personal.newAccount(\"$pass\")" | geth --verbosity 1 --datadir=$PWD/simbel/data console 
	fi
    fi
    if [ "$choice" = 2 ]; then
	tmux kill-session -t geth
	#tmux kill-session -t ipfs
	if [[ "$arch" == 'armhf' ]]; then
		./geth --verbosity 1 --datadir=$PWD/simbel/data console <<< $'eth.accounts'
	else
		geth --verbosity 1 --datadir=$PWD/simbel/data console <<< $'eth.accounts'
	fi

	echo $PID
    fi
    if [ "$choice" = 3 ]; then
	tmux kill-session -t geth
	#tmux kill-session -t ipfs

	read -p "Enter your Ethereum address (without quotes). E.g. 0x...
> " addr
 	read -p "Enter your network id (or leave blank for default value 4828): " networkId
	read -p "Enter port (or leave blank for default value 30303): " port
	read -p "Enter rpc port (or leave blank for default value 8545): " rpcport

	if [ -z "$networkId" ]; then
	    networkId=4828
	fi
	if [ -z "$port" ]; then
	    port=30303
	fi
	if [ -z "$rpcport" ]; then
	    rpcport=8545
	fi
	if [[ "$arch" == 'armhf' ]]; then
		./geth --verbosity 3 --datadir=$PWD/simbel/data --mine --minerthreads=1 --etherbase "$addr"
	else
		geth --verbosity 3 --datadir=$PWD/simbel/data --mine --minerthreads=1 --etherbase "$addr"
	fi
	

    fi
    if [ "$choice" = 4 ]; then
	./deploy.sh
    fi

    # start Simbel    
    if [ "$choice" = 5 ]; then
	echo log_nodeInfo

	./log_nodeInfo.sh	

 	#read -p "Enter your network id (or leave blank for default value 4828): " networkId
	#read -p "Enter port (or leave blank for default value 30303): " port
	#read -p "Enter rpc port (or leave blank for default value 8545): " rpcport
	if [ -z "$networkId" ]; then
	    networkId=4828
	fi
	if [ -z "$port" ]; then
	    port=30303
	fi
	if [ -z "$rpcport" ]; then
	    rpcport=8545
	fi
	# create geth.ipc file
	if [[ "$arch" == 'armhf' ]]; then
       		echo "exit" | ./geth --verbosity 2 --datadir=$PWD/simbel/data --networkid "$networkId" --port "$port" --rpc --rpcport "$rpcport" console		
	else
       		echo "exit" | geth --verbosity 2 --datadir=$PWD/simbel/data --networkid "$networkId" --port "$port" --rpc --rpcport "$rpcport" console		

	fi
	if [[ "$arch" == 'armhf' ]]; then
        	tmux new-session -d -s geth "./geth --verbosity 3 --datadir=$PWD/simbel/data --networkid $networkId --port $port  --rpcapi=\"db,eth,net,personal,web3\" --rpc --rpcport $rpcport console"
	else
        	tmux new-session -d -s geth "geth --verbosity 3 --datadir=$PWD/simbel/data --networkid $networkId --port $port  --rpcapi=\"db,eth,net,personal,web3\" --rpc --rpcport $rpcport console"
	fi
	#tmux new-session -d -s ipfs 'ipfs daemon'
	sleep 5

	python3 $PWD/simbel/main.py
    fi

    if [[ "$choice" = 6 ]]; then

	if [[ "$arch" == 'armhf' ]]; then
		output="$(./geth --datadir=$PWD/simbel/data console <<< $'admin.nodeInfo')"
	else
		output="$(geth --datadir=$PWD/simbel/data console <<< $'admin.nodeInfo')"
	fi
	echo ""
	echo ""
	echo ""
	if [[ "$output" =~ \"enode[^,]* ]]; then
    		echo "your enode is:  ${BASH_REMATCH[0]}"
	fi

	genesis=`cat $PWD/simbel/genesis.json`

	if [[ "$genesis" =~ difficulty[^,]* ]]; then
		diff=${BASH_REMATCH[0]:15:6}
		echo difficulty: "$diff"
	fi

	if [[ "$genesis" =~ nonce[^,]* ]]; then
		nonce=${BASH_REMATCH[0]:15}
		echo nonce: \""$nonce"
	fi

	if [[ "$genesis" =~ chainId[^,]* ]]; then
		chainId=${BASH_REMATCH[0]:9:6}
		echo chainId: "$chainId"
	fi
	echo ""
	echo ""
	echo ""

    fi

    if [[ "$choice" = 7 ]]; then
	read -p "Enter enode address (without quotes). Example:  enode://...@ip_address:port
" enode

	num_lines=`cat $PWD/simbel/data/static-nodes.json | wc -l`
	i=0

	while IFS= read -r line 
	do
	    if [[ $num_lines -gt 2 ]] && [[ $i -eq $[num_lines-2] ]]; then
	        echo add comma
		echo "$line", >> $PWD/simbel/data/static-nodes2.json
	    else
		echo "$line" >> $PWD/simbel/data/static-nodes2.json
	    fi

	    if [ $i = $[$num_lines-2] ]; then
	        echo \""$enode"\" >> $PWD/simbel/data/static-nodes2.json
	    fi
	    i=$[i+1]

	done < "$PWD/simbel/data/static-nodes.json"

	mv $PWD/simbel/data/static-nodes2.json $PWD/simbel/data/static-nodes.json

    fi

    if [[ "$choice" = 8 ]]; then
 	read -p "Enter your network id (or leave blank for default value 4828): " networkId
	read -p "Enter port (or leave blank for default value 30303): " port
	read -p "Enter rpc port (or leave blank for default value 8545): " rpcport

	if [ -z "$networkId" ]; then
	    networkId=4828
	fi
	if [ -z "$port" ]; then
	    port=30303
	fi
	if [ -z "$rpcport" ]; then
	    rpcport=8545
	fi
	if [[ "$arch" == 'armhf' ]]; then
       		./geth --verbosity 2 --datadir=$PWD/simbel/data --networkid "$networkId" --port "$port" --rpc --rpcport "$rpcport" console
	else
       		geth --verbosity 2 --datadir=$PWD/simbel/data --networkid "$networkId" --port "$port" --rpc --rpcport "$rpcport" console
	fi
   fi

    if [[ "$choice" = 9 ]] || [[ "$choice" == "exit" ]] || [[ "$choice" == "quit" ]]; then
	tmux kill-session -t geth
	#tmux kill-session -t ipfs

        finished=true
    fi

done
exit 0
