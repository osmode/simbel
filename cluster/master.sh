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

mkdir mpich2

cd ~/mpich2

wget http://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1.tar.gz

tar xfz mpich-3.2.1.tar.gz

sudo mkdir /home/rpimpi/

sudo mkdir /home/rpimpi/mpi-install

mkdir /home/pi/mpi-build

cd /home/pi/mpi-build

sudo apt-get install gfortran

sudo /home/pi/mpich2/mpich-3.2.1/configure -prefix=/home/rpimpi/mpi-install

sudo make

sudo make install

nano .bashrc

PATH=$PATH:/home/rpimpi/mpi-install/bin

sudo reboot

mpiexec -n 1 hostname

echo These commands will download and install MPICH, as well as add it as a path to your BASHRC boot file. The last command runs a test to see if it works. If the last command returns “Pi01”, then you did everything successfully.

echo As it is, MPICH can run C and Fortran programs. But since the Raspberry Pi has the Python coding environment pre-installed, it would be easiest to install a Python to MPI interpreter. Here’s the commands to do that:

sudo aptitude install python-dev

wget https://mpi4py.googlecode.com/files/mpi4py-1.3.1.tar.gz

tar -zxf mpi4py-1.3.1

cd mpi4py-1.3.1

python setup.py build

python setup.py install

export PYTHONPATH=/home/pi/mpi4py-1.3.1

mpiexec -n 5 python demo/helloworld.py

echo That last command should return five responses. Each one is a different process on Pi01 running the python program "Hello World" that we just made.

echo Now that we've successfully configured our master Pi, we need to copy that Pi's SD card image to all the other Pi's...

