#!/bin/bash
# log_simbelnet_nodeInfo.sh
# Save local enode to file when connecting to Simbel Ethereum network
# clear old nodeInfo.ds file
rm $PWD/simbel/nodeInfo.ds

# check OS
os="$(uname -s)"
# if Mac OS X
if [ "$os" = 'Darwin' ]; then
	output="$(geth --datadir=$PWD/simbel/data console <<< $'admin.nodeInfo')"
	arch="Mac"
else
	arch="$(dpkg  --print-architecture)"
fi
# if Raspberry Pi
if [[ "$arch" == 'armhf' ]]; then
	output="$(./geth --datadir=$PWD/simbel/data console <<< $'admin.nodeInfo')"
# if Linux and not Raspberry Pi
else
	output="$(geth --datadir=$PWD/simbel/data console <<< $'admin.nodeInfo')"
fi

if [[ "$output" =~ \"enode[^,]* ]]; then
echo "your enode is:  ${BASH_REMATCH[0]}"
echo "${BASH_REMATCH[0]}" >> $PWD/simbel/nodeInfo.ds
fi

output="$(ifconfig)"
result=$(echo "$output" | (grep -oE "\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b" | head -1))

echo your ip address is: ${result} 
echo "${result}" >> $PWD/simbel/nodeInfo.ds

