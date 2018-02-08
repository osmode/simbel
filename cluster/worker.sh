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
cp /home/pi/.ssh/id_rsa.pub pi01
ssh pi@10.0.0.243
ssh-keygen -b 2048 -t rsa
cp /home/pi/.ssh/id_rsa.pub pi02
scp 10.0.0.26:/home/pi/.ssh/pi01
ssh pi@10.0.0.233
ssh-keygen -b 2048 -t rsa
cp /home/pi/.ssh/id_rsa.pub pi03
cat /home/pi/.ssh/pi01 >> authorized_keys
cat /home/pi/.ssh/pi02 >> authorized_keys
cat /home/pi/.ssh/pi03 >> authorized_keys

exit

