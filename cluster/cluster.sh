#!/bin/bash
# Script to initialize a worker node in a 
# Raspberry Pi cluster
# Modified from: http://www.instructables.com/id/How-to-Make-a-Raspberry-Pi-SuperComputer/
# Author: Omar N. Metwally, MD
# omar.metwally@gmail.com
# https://github.com/osmode/simbel
# USAGE:  ./worker.sh 
echo We now need to create a new ssh keypair.
ssh-keygen -b 2048 -t rsa
# CHANGE pi04 below to the corresponding raspberry pi node in your cluster
cp /home/pi/.ssh/id_rsa.pub pi04

# copy public keys from all rasperry pi's in the cluster
scp 10.0.0.26:/home/pi/.ssh/pi01 /home/pi/.ssh/pi01
scp 10.0.0.243:/home/pi/.ssh/pi02 /home/pi/.ssh/pi02
scp 10.0.0.233:/home/pi/.ssh/pi03 /home/pi/.ssh/pi03
scp 10.0.0.142:/home/pi/.ssh/pi04 /home/pi/.ssh/pi04

# add all pis' public keys to authorized_keys
cat /home/pi/.ssh/pi01 >> authorized_keys
cat /home/pi/.ssh/pi02 >> authorized_keys
cat /home/pi/.ssh/pi03 >> authorized_keys
cat /home/pi/.ssh/pi04 >> authorized_keys

exit
