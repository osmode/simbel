#!/bin/bash
arch="$(dpkg  --print-architecture)"
rm $PWD/simbel/nodeInfo.ds

if [[ "$arch" == 'armhf' ]]; then
	output="$(./geth --datadir=$PWD/simbel/data console <<< $'admin.nodeInfo')"

	if [[ "$output" =~ \"enode[^,]* ]]; then
	    echo "your enode is:  ${BASH_REMATCH[0]}"
	    echo "${BASH_REMATCH[0]}" >> $PWD/simbel/nodeInfo.ds
	fi

	output="$(ifconfig)"

	result=$(echo "$output" | (grep -oE "\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b" | head -1))

	echo your ip address is: ${result} 
	echo "${result}" >> $PWD/simbel/nodeInfo.ds

# if not Linux-arm architecture
else

	output="$(geth --datadir=$PWD/simbel/data console <<< $'admin.nodeInfo')"

	if [[ "$output" =~ \"enode[^,]* ]]; then
	    echo "your enode is:  ${BASH_REMATCH[0]}"
	    echo "${BASH_REMATCH[0]}" >> $PWD/simbel/nodeInfo.ds
	fi

	output="$(ifconfig)"

	result=$(echo "$output" | (grep -oE "\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b" | head -1))

	echo your ip address is: ${result} 
	echo "${result}" >> $PWD/simbel/nodeInfo.ds
fi

