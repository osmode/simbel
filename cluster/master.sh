#!/bin/bash
# Script to initialize the master node in a 
# Raspberry Pi cluster
# Based on: http://www.instructables.com/id/How-to-Make-a-Raspberry-Pi-SuperComputer/
# Author: Omar N. Metwally, MD
# omar.metwally@gmail.com
# https://github.com/osmode/simbel
# USAGE:  ./master.sh 
echo we now need to install the primary software that is going to allow us to use the processing power of all the Pi's on our network. That software is called MPICH, which is a Message Passing Interface. Here's what you need to do to install it:

sudo apt-get update

mkdir ~/mpich2

cd ~/mpich2

wget http://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1.tar.gz

tar xfz mpich-3.2.1.tar.gz

sudo mkdir /home/rpimpi/

sudo mkdir /home/rpimpi/mpi-install

sudo apt-get install nmap

mkdir /home/pi/mpi-build

cd /home/pi/mpi-build

sudo apt-get install gfortran

sudo /home/pi/mpich2/mpich-3.2.1/configure -prefix=/home/rpimpi/mpi-install

sudo make

sudo make install

vim .bashrc

echo PATH=$PATH:/home/rpimpi/mpi-install/bin >> $HOME/.bashrc

mpiexec -n 1 hostname

echo These commands will download and install MPICH, as well as add it as a path to your BASHRC boot file. The last command runs a test to see if it works. If the last command returns “Pi01”, then you did everything successfully.

echo That last command should return five responses. Each one is a different process on Pi01 running the python program "Hello World" that we just made.

echo Now that we've successfully configured our master Pi, we need to run .worker.sh scripts on the other pis

