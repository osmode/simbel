#!/bin/bash
# Script to initialize a raspberry pi cluster
# Run this second (after master.sh)
# Modified from: http://www.instructables.com/id/How-to-Make-a-Raspberry-Pi-SuperComputer/
# Author: Omar N. Metwally, MD
# omar.metwally@gmail.com
# https://github.com/osmode/simbel
# USAGE:  ./cluster.sh 

# copy arm-architecture geth binary into this directory
sudo cp /home/pi/simbel/geth /home/rpimpi/mpi-install/bin/geth

# copy public keys from all rasperry pi's in the cluster
scp 10.0.0.26:/home/pi/.ssh/pi01 /home/pi/.ssh/pi01
scp 10.0.0.243:/home/pi/.ssh/pi02 /home/pi/.ssh/pi02
scp 10.0.0.233:/home/pi/.ssh/pi03 /home/pi/.ssh/pi03
scp 10.0.0.142:/home/pi/.ssh/pi04 /home/pi/.ssh/pi04

# add all pis' public keys to authorized_keys
cat /home/pi/.ssh/pi01 >> /home/pi/.ssh/authorized_keys
cat /home/pi/.ssh/pi02 >> /home/pi/.ssh/authorized_keys
cat /home/pi/.ssh/pi03 >> /home/pi/.ssh/authorized_keys
cat /home/pi/.ssh/pi04 >> /home/pi/.ssh/authorized_keys

exit
