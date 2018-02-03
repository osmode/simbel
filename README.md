Simbel - Ethereum Operating System
======================================================
[Github repository](https://github.com/simbel/simbel)

[Project website](https://simbel.github.io/simbel/)
------------------------------------------------------

![Simbel gif](https://s3-us-west-1.amazonaws.com/simbel/home.png)

## What is Simbel?
---
Simbel is an Ethereum operating system for knowledge creation and sharing

* Transfer value and information across Ethereum networks

* Abstract creation of GUI interfaces for Ethereum contracts

* Sysadmin for Ethereum networks  

* Interface with the Interplanetary File System ([IPFS](https://github.com/ipfs/ipfs)) to minimize on-chain storage 


## Mission Statement

### Our goal is to build open economies for information exchange within and among organizations.

## Universal Consensus Time
Simbel sets network time by blockchain consensus. 

![Simbel](https://s3-us-west-1.amazonaws.com/ddash/simbel.png)

## Manifesto 
The Manifesto contract allows participants to create a manifesto through a transparent voting process. Anyone can submit and vote on proposals. To interface with your own custom voting contracts (on any Ethereum network), simply replace the default Manifesto.sol address with your contract's address.


![Manifesto Contract](https://s3-us-west-1.amazonaws.com/simbel/manifesto5.png)

## Why Simbel?
Simbel combines the benefits of private Ethereum networks with the benefits of the Ethereum main network. Simbel allows Ethereum applications to run cheaply and securely on private Ethereum networks while enabling their integration with the main Ethereum network. The result is greatly reduced development and operational costs associated with private Ethereum networks, combined with the ability to transfer value and information among the main Ethereum network and private Ethereum networks.

# Quickstart 
Simbel, the Simbel Installer, and the Simbel Network Utility currently support Ubuntu MATE (Raspberry Pi), Ubuntu 16.04, and Mac OS X.

Downlod or clone this repository to your machine, and navigate to that directory. Run these commands carefully and in order:  

1. Permissions

Allow execution of installation and network deployment scripts. 
Allow execution of the Go Ethereum client (binary optimized for ARM architecture).
```
chmod +x *.sh geth
```

2. Installation

Run installation script. 
```
./install.sh
```
This will install the necessary dependencies your machine needs to run Simbel. The installation process can take a long time depending on what's already installed on your machine. The installer will explicitly ask for permission to install each dependency via yes/no prompts. You will be prompted to enter your system password before performing actions that require superuser privileges.

3. Start Simbel

Use the Simbel Networking Utility to create and manage Ethereum accounts and start the Simbel Command Line Interface (CLI).
```
./snu.sh
```

To start *Twin Peaks*, Simbel's Graphical User Interface, run:
```
python3 gui.py
```

## Directory structure
The directory structure is important because Simbel and the Simbel Networking Utility look for certain files in certain directories. Your application will look something like this:
```
/your_working_directory
	README.md
	install.sh
	dnu.sh
	deploy.sh
	log_nodeInfo.sh
	load_mainnet.sh
	load_blackswan.sh 

	/simbel
		crypto.py
		genesis.json
		bcinterface.py
		fsinterface.py
		ipfs.py
		main.py
		nodeInfo.ds
		
        /source
		/data
	    	static-nodes.json

	/share
	/swap

```
Save Ethereum contracts in the *source* directory with the .sol extension.


## NFO Coin
NFO Coin is the utility token that powers Simbel, enabling the exchange of information and value across Ethereum networks. NFO Coin is based on the ERC20 standard. The NFO ABI and contract are located in the source directory and can be directly inspected at address 0x3100047369b54c34042B9DC138C02A0567D90A7a on the Ethereum main network.

### totalSupply: 10,000,000
### tokenName: NFO Coin
### tokenSymbol: NFO

There are 10,000,000 NFO Coin in circulation, which can be exchanged for Ether at a rate of 1,000 NFO Coin per 1 Ether.

NFO Coin and Ether can be exchanged using the Simbel client, which can be launched by running 
```
python3 gui.py 
```

## Contribute
Please take a look at our [contribution documentation](https://github.com/simbel/simbel/blob/master/docs/CONTRIBUTING.md) for information on how to report bugs, suggest enhancements, and contribute code. If you or your organization use Simbel to do something that would otherwise be impossible using traditional system, please share your experience! 

## Code of conduct
In the interest of fostering an open and welcoming environment, we as contributors and maintainers pledge to making participation in our project and our community a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation. Read the full [Contributor Covenant](https://github.com/simbel/simbel/blob/master/docs/CODE_OF_CONDUCT.md). 

## Prerequisites
This project builds on work by the [Ethereum](https://www.ethereum.org), [web3.py](https://github.com/pipermerriam/web3.py), [IPFS](https://github.com/ipfs/ipfs) and [py-ipfs](https://github.com/ipfs/py-ipfs-api) communities. 

The Simbel Installer, which currently supports Ubuntu 16.04 and Mac OS, installs all dependencies (including the Go Ethereum client).

## License
[MIT License](https://github.com/simbel/simbel/blob/master/LICENSE) 

