'''
--------------------------------------------
main.py
--------------------------------------------
Simbel - Ethereum Operating System 
for Knowledge Creation and Sharing
Command Line Interface (CLI)
--------------------------------------------
Omar Metwally, MD (omar.metwally@gmail.com)
https://github.com/simbel/simbel
--------------------------------------------
'''

from bcinterface import BCInterface
from getpass import getpass
from fsinterface import *

ethereum_acc_pass = None

# Flags to instruct Simbel to broadcast enode address to blockchain
# and query blockchain for peer enodes
BROADCAST=True
LISTEN=True
simbel_contract_address="0x1622da6805c7b5e5e38f7b88b5e533938ff800da"
recordmanager_contract_address="0xcc109bf72338909ead31a5bf46d8d8fa455ff09b"
swap_contract_addresses = ["0xed8c634ac8c2fa3694c32cb01b96a6912f8a7738", "0x5fced4408a9ff19091a97a616e8432d00b808098"]

intro = r"""
		S I M B E L

"""
def get_value_from_index(input_phrase,index,convert_to='integer'):
	input_phrase = input_phrase.split()
	value =None

	try:
		if convert_to is 'string': value = str(input_phrase[index])
		elif convert_to is 'integer': value = int(input_phrase[index]) 
		else: value = int(input_phrase[index])

	except:
		print("ValueFromIndex Error.")

	return value


print(intro)

def get_contract_name_and_address():
	contract_name=None
	contract_address=None

	#contract_name=input("Enter your contract name (leave blank for simbel)> ")
	while 1:
		#contract_address=input("Enter your contract address (leave blank for simbel)> ")
		if not contract_address: 
			contract_address=simbel_contract_address

		if not contract_name: 
			contract_name='simbel' 

		if contract_address and contract_name: break

	return contract_name, contract_address

bci = BCInterface(mainnet=False)
fsi = FSInterface()
contract_name, contract_address = get_contract_name_and_address()
bci.load_contract(contract_name=contract_name, contract_address=contract_address)
loop_counter = 0

while 1:
	result = input("simbel> ")
	BROADCAST=False
	LISTEN=False

	if 'quit' in result or 'exit' in result: break

	if 'sanity check' in result:
		bci.sanity_check()

	if ('upload' in result):
		print("uploading contents of "+os.getcwd()+"/simbel/share...")
		if not ethereum_acc_pass:
			print("Enter password for account "+bci.eth_accounts[0]+":")
			ethereum_acc_pass=getpass() 
		bci.unlock_account(ethereum_acc_pass)
		bci.load_contract(contract_name='recordmanager',contract_address=recordmanager_contract_address)

		fsi.upload_all_files(bci)
	
	if ('download' in result):
		print("downloading blockchain contents to "+os.getcwd()+"/simbel/share...")
		if not ethereum_acc_pass:
			print("Enter password for account "+bci.eth_accounts[0]+":")
			ethereum_acc_pass=getpass() 
		bci.unlock_account(ethereum_acc_pass)

		bci.load_contract(contract_name='recordmanager',contract_address=recordmanager_contract_address)

		fsi.download_all_files(bci)

	if ('show account' in result):
		bci.show_eth_accounts()

	elif ('use account' in result) or ('set account' in result):
		if not ethereum_acc_pass:
			print("Enter password for account "+bci.eth_accounts[0]+":")
			ethereum_acc_pass=getpass() 
		bci.unlock_account(ethereum_acc_pass)

		account_index = get_value_from_index(result,2,convert_to="integer")
		bci.set_account(account_index)

	if ('unlock' in result):
		password = get_value_from_index(result,2,convert_to="string")
		bci.unlock_account(password)

	if ('checkout' in result):
		ipfs_hash = get_value_from_index(result,1,convert_to="string")
		print("Looking for this IPFS hash on the blockchain:",ipfs_hash)
		bci.get_record(ipfs_hash)

	if 'set gas' in result:
		new_gas_amount = get_value_from_index(result,2,convert_to="integer")
		print("Setting gas to ",new_gas_amount,"...")
		bci.set_gas(new_gas_amount)

	if ( ('broadcast' in result) or BROADCAST):
		if not ethereum_acc_pass:
			print("Enter password for account "+bci.eth_accounts[0]+":")
			ethereum_acc_pass=getpass() 
		bci.unlock_account(ethereum_acc_pass)
		bci.load_contract(contract_name='simbel',contract_address=simbel_contract_address)
		enode = fsi.my_enode()  #'myenode123' # my_enode()
		if enode:
			print("Broadcasting enode "+enode+" to the simbel network.")
		else:
			print('no enode registered')

		# this transaction requires sufficient Ether balance
		try:
			print(bci.contract.transact(bci.tx).add_entity(enode))
		except:
			print('unable to call method add_entity')
			pass

	if ( ('listen' in result) or LISTEN):
		if not ethereum_acc_pass:
			print("Enter password for account "+bci.eth_accounts[0]+":")
			ethereum_acc_pass=getpass() 
		bci.unlock_account(ethereum_acc_pass)
		bci.load_contract(contract_name='simbel',contract_address=simbel_contract_address)

		print("Downloading peer list from blockchain.")
		peers = []
		try:
			num_peers = bci.contract.call().get_entity_count()
		except:
			num_peers=0
		if num_peers == 0:
			print("No peers found on chain.")
		else:
			print(str(num_peers)+" peers found on chain.")

		y=0
		while y<num_peers:
			p = bci.contract.call().get_row(y)
			print('row: ',str(p))
			enode = p[0]
			timestamp = p[1]
			print("Adding to list of peers:")
			print(enode)
			peers.append(enode)
			fsi.add_static_node(enode)
			y+=1

	# greet simbel
	if ('greet simbel' in result) or ('simbel' in result) or ('hello' in result) or ('hi' in result):
		if not ethereum_acc_pass:
			print("Enter password for account "+bci.eth_accounts[0]+":")
			ethereum_acc_pass=getpass() 
		bci.unlock_account(ethereum_acc_pass)
		bci.load_contract(contract_name='simbel',contract_address=simbel_contract_address)

		bci.heyo()

	if 'contract' in result:
		args = result.split()
		if len(args) != 3:
			print("Example of correct usage:  contract simbel "+simbel_contract_address)
		else:
			contract_name = args[1].strip()
			contract_address = args[2].strip()
			bci.load_contract(contract_name=contract_name, contract_address=contract_address)

	if  'peer count' in result:
		if not ethereum_acc_pass:
			print("Enter password for account "+bci.eth_accounts[0]+":")
			ethereum_acc_pass=getpass() 
		bci.unlock_account(ethereum_acc_pass)
		bci.load_contract(contract_name='simbel',contract_address=simbel_contract_address)

		bci.peer_count()


	loop_counter+=1

