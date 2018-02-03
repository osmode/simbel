#!/bin/bash
# Simbel Networking Utility
# Author: Omar N. Metwally, MD
# omar.metwally@gmail.com
# https://github.com/osmode/simbel
# USAGE:  ./install.sh 
# Installs Simbel dependencies

finished=false
pwd=$(PWD)

while [ $finished = false ] 
do
	read -p "
Welcome to the Simbel Installer. What would you like to do?
1: Install Simbel and Simbel Networking Utility
2: Reset chain data 
3: Exit

Your choice> " choice

    if [ "$choice" = 1 ]; then
	tmux kill-session -t geth
	#tmux kill-session -t ipfs
	echo -e "\033[1;32mSimbel will now attempt to install necessary dependencies on your machine. \033[0m"

	echo ""
	os="$(uname -s)"
	if [ "$os" = 'Darwin' ]; then
		echo "It appears you're installing Simbel on a Mac."

		while true; do
		read -p "Would you like to install Homebrew? Enter Y/n: " answer1
			if [[ "$answer1" = 'y' ]] || [[ "$answer1" = 'Y' ]] || [[ "$answer1" = 'n' ]] || [[ "$answer1" = 'N' ]]; then
				break
			fi
		done
			
		if [[ "$answer1" = 'Y' ]] || [[ "$answer1" = 'y' ]]; then
		    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		    brew update
		fi

		while true; do
		read -p "Would you like to install Python3? Enter Y/n: " answer_python3
			if [[ "$answer_python3" = 'y' ]] || [[ "$answer_python3" = 'Y' ]] || [[ "$answer_python3" = 'n' ]] || [[ "$answer_python3" = 'N' ]]; then
				break
			fi
	
	 
		done
		if [[ "$answer_python3" = 'y' ]] || [[ "$answer_python3" = 'Y' ]]; then
			brew install python3
		fi

		while true; do
		read -p "Would you like to install the Go compiler? Enter Y/n: " answer2
			if [[ "$answer2" = 'y' ]] || [[ "$answer2" = 'Y' ]] || [[ "$answer2" = 'N' ]] || [[ "$answer2" = 'n' ]]; then
				break
			fi
		done

		if [[ "$answer2" = 'Y' ]] || [[ "$answer2" = 'y' ]]; then
		    brew update
		    brew install go
		fi

		while true; do
		read -p "Would you like to install the Go Ethereum client? Enter Y/n: " answer3
			if [[ "$answer3" = 'y' ]] || [[ "$answer3" = 'Y' ]] || [[ "$answer3" = 'N' ]] || [[ "$answer3" = 'n' ]]; then
				break
			fi
		done	

		if [[ "$answer3" = 'Y' ]] || [[ "$answer3" = 'y' ]]; then
		    brew tap ethereum/ethereum
		    brew install ethereum
		fi

		while true; do
		read -p "Would you like to install Node and npm? Enter Y/n: " answer4
			if [[ "$answer4" = 'y' ]] || [[ "$answer4" = 'Y' ]] || [[ "$answer4" = 'N' ]] || [[ "$answer4" = 'n' ]]; then
				break
			fi
		done	
		if [[ "$answer4" = 'Y' ]] || [[ "$answer4" = 'y' ]]; then
		    brew install node
		fi
		while true; do
		read -p "Would you like to install the solC compiler? Enter Y/n: " answer5
			if [[ "$answer5" = 'y' ]] || [[ "$answer5" = 'Y' ]] || [[ "$answer5" = 'N' ]] || [[ "$answer5" = 'n' ]]; then
				break
			fi
		done	
		if [[ "$answer5" = 'Y' ]] || [[ "$answer5" = 'y' ]]; then
		    npm install -g solc	    
		fi
		while true; do
		read -p "Would you like to install tmux? Enter Y/n: " answer6
			if [[ "$answer6" = 'y' ]] || [[ "$answer6" = 'Y' ]] || [[ "$answer6" = 'N' ]] || [[ "$answer6" = 'n' ]]; then
				break
			fi	
		done
		if [[ "$answer6" = 'Y' ]] || [[ "$answer6" = 'y' ]]; then
		    brew install tmux
		fi

	fi
	if [ "$os" = 'Linux' ]; then
		echo "Installing Ubuntu dependencies..."
		if [[ "$arch" == 'armhf' ]]; then
			echo -e "\033[0;31mIt appears you're installing Simbel on a Raspberry Pi!  :)"

		fi

		sudo apt-get update
		sudo apt-get install tmux
		#sudo apt-get install software-properties-common
		#sudo add-apt-repository -y ppa:ethereum/ethereum
		#sudo apt-get install ethereum
		#sudo add-apt-repository ppa:ethereum/ethereum
		#sudo apt-get update
		#sudo apt-get install solc
	    	sudo apt-get install python3-pip

	fi

	#if [ ! -f /usr/local/bin/ipfs ]; then
	#    wget https://dist.ipfs.io/go-ipfs/v0.4.10/go-ipfs_v0.4.10_linux-386.tar.gz
	#    tar xvfz go-ipfs_v0.4.10_linux-386.tar.gz
	#    mv go-ipfs/ipfs /usr/local/bin/ipfs
	#    rm go-ipfs_v0.4.10_linux-386.tar.gz
	#fi

	#ipfs init
	pip3 install web3
	#pip3 install ipfsapi
	
	# clear old chain data (!)
	sudo rm -r $PWD/simbel/data/geth

	if [ ! -d $PWD/simbel ]; then
	    mkdir -p $PWD/simbel;
	    mkdir -p $PWD/simbel/data;
	    mkdir -p $PWD/simbel/source;
	fi

	#read -p "Please specify chainId (or leave blank for default): " chainId
	if [ -z $chainId ]; then
		chainId=32
	fi		
	#read -p "Please specify mining difficulty (or leave blank for default): " diff
	#read -p "Please specify nonce (or leave blank for default): " nonce
	if [ -z $nonce ]; then
		nonce=32
	fi
	#read -p "Please specify a gas limit (leave leave blank for default value 0x5FDFB0): " gaslimit

	if [ -f $PWD/simbel/genesis.json ]; then
	    rm $PWD/simbel/genesis.json
	fi

	sudo echo "{" >> $PWD/simbel/genesis.json
	sudo echo "  \"config\":  {" >> $PWD/simbel/genesis.json
	sudo echo "        \"chainId\": $chainId, " >> $PWD/simbel/genesis.json
	sudo echo "        \"homesteadBlock\": 0," >> $PWD/simbel/genesis.json
	sudo echo "        \"eip155Block\": 0,">> $PWD/simbel/genesis.json
	sudo echo "        \"eip158Block\": 0" >> $PWD/simbel/genesis.json
	sudo echo "    }," >> $PWD/simbel/genesis.json
	sudo echo "  \"alloc\": {" >> $PWD/simbel/genesis.json
	sudo echo "  }," >> $PWD/simbel/genesis.json
	sudo echo "  \"coinbase\"   : \"0x0000000000000000000000000000000000000000\", " >> $PWD/simbel/genesis.json

	# if no difficulty is specified, use default
	if [ -z $diff ]; then
	    echo "No difficulty specified. Using default."
	    sudo echo "  \"difficulty\" : \"0xF4240\", " >> $PWD/simbel/genesis.json
	else
	    echo User-defined difficulty: "$diff"
	    sudo echo "  \"difficulty\" : \"$diff\", " >> $PWD/simbel/genesis.json
	fi
	sudo echo "  \"extraData\"  : \"\", " >> $PWD/simbel/genesis.json
	if [ -z $gaslimit ]; then
	    echo "No gas limit specified. Using default..."
	    sudo echo "  \"gasLimit\"   : \"0x5FDFB0\", " >> $PWD/simbel/genesis.json
	else 
	    sudo echo User-defined gas limit: "$gaslimit"	
	    sudo echo "  \"gasLimit\"   : \""$gaslimit"\", " >> $PWD/simbel/genesis.json
	fi

	if [ -z $nonce ]; then
	    sudo echo "  \"nonce\"      : \"0x000000$RANDOM\", " >> $PWD/simbel/genesis.json
	else
	    sudo echo "  \"nonce\"      : \"0x000000$nonce\", " >> $PWD/simbel/genesis.json
	fi

	sudo echo "  \"mixhash\"    : \"0x0000000000000000000000000000000000000000000000000000000000000000\", " >> $PWD/simbel/genesis.json
	sudo echo "  \"parentHash\" : \"0x0000000000000000000000000000000000000000000000000000000000000000\", " >> $PWD/simbel/genesis.json
	sudo echo "  \"timestamp\"  : \"0x00\" " >> $PWD/simbel/genesis.json
	sudo echo "}" >> $PWD/simbel/genesis.json

	chmod +x geth
	chmod +x log_nodeInfo.sh
	geth --datadir=$PWD/simbel/data init $PWD/simbel/genesis.json

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

        echo "exit" | geth --verbosity 2 --datadir=$PWD/simbel/data --networkid "$networkId" --port "$port" --rpc --rpcport "$rpcport" console

	#rm -r $PWD/go-ipfs
	# save enode information
	./log_nodeInfo.sh

echo -e "\033[1;32mCongratulations! Simbel has been installed on your machine. I will now attempt to start the GUI. \033[0m"

python3 gui.py

    fi  # end if [ "$choice" =1 ]

    if [ "$choice" = 2 ]; then
	sudo rm -r $PWD/simbel/data/geth
	sudo rm -r $PWD/simbel/data_mainnet/geth
	#sudo rm $PWD/simbel/genesis.json
	#sudo rm $PWD/simbel/nodeInfo.ds
	echo Chain cleared from $PWD/simbel/data/geth. Genesis file deleted.
    fi

    if [[ "$choice" = 3 ]] || [[ "$choice" == "exit" ]] || [[ "$choice" == "quit" ]]; then
	exit
    fi
done

echo -e "\033[1;32mCongratulations! Simbel has been installed on your machine. I will now attempt to start the GUI. \033[0m"

python3 gui.py

