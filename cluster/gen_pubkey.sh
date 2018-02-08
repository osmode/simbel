#!/bin/bash
# Script to create a new public key  for a node in a Rasperry Pi cluster
# Modified from: http://www.instructables.com/id/How-to-Make-a-Raspberry-Pi-SuperComputer/
# Author: Omar N. Metwally, MD
# omar.metwally@gmail.com
# https://github.com/osmode/simbel
# USAGE:  ./gen_pubkey.sh 
echo We now need to create a new ssh keypair.
ssh-keygen -b 2048 -t rsa
read -p 'Enter your node id (e.g. pi01, pi02, etc...):  ' id
cp /home/pi/.ssh/id_rsa.pub /home/pi/.ssh/$id

exit
