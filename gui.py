'''
--------------------------------------------
gui.py
--------------------------------------------
Simbel - Ethereum Operating System 
for Knowledge Creation and Sharing
Twin Peaks graphical user interface for
--------------------------------------------
Omar Metwally, MD (omar.metwally@gmail.com)
https://github.com/simbel/simbel
--------------------------------------------
'''
from tkinter import simpledialog, messagebox
from tkinter import *
from tkinter.font import Font
from tkinter import ttk
import subprocess, os
from subprocess import call
import sys, datetime
from random import randrange

sys.path.insert(0, os.path.join(os.getcwd(),'simbel'))
from bcinterface import *
from simbel import *
from getpass import getpass
import time, atexit

# Flags to instruct Simbel to broadcast enode address to blockchain
# and query blockchain for peer enodes
BROADCAST=False
LISTEN=False

simbel_contract_address="0x1622da6805c7b5e5e38f7b88b5e533938ff800da"

# available Ethereum networks
NETWORK_OPTIONS = [ "Simbel", "Main Ethereum network" ]
# list of available contracts to interface with
CONTRACT_OPTIONS = [ ]
# list of Ethereum accounts, popuated at runtime
ACCOUNT_OPTIONS = []
# logo displayed in upper left corner
intro = r"""simbel"""

'''
@class TwinPeaks
Represents the simbel graphical user interface 
Built on tkinter (Python 3)
@parameter master is a tkinter root object
'''
class TwinPeaks:
	def __init__(self, master):
		self.master = master
		master.title("simbel")
		# @variable self.network can be main net, simbel, or another private net
		self.network=None
		# @variable self.context represents the current contract, or the home screen
		self.context = "home"
		# @variable self.network_variable populates the Ethereum network
		# dropdown on the home screen. Default is main net
		self.network_variable = StringVar()
		self.network_variable.set(NETWORK_OPTIONS[0])
		self.account_variable = StringVar(self.master)
		# @variable self.bci is initialized to a @class BCInterface object
		# which interfaces with Ethereum contracts pythonically via web3
		self.bci = None
		# @variable self.fsi is initialized to a @class FSInterface object,
		# which interfaces with the local file system
		self.fsi = None
		self.ethereum_acc_pass = None
		self.ready = False
		# in the Manifesto.sol context, used to tally votes
		self.last_selected_proposalID = None

	'''
	@method handle_selected_contract
	Place checkmark next to contract name when it's seleced in menu bar	
	@parameter mn is the Contract menubar
	@parameter index corresponds to the index of the contract selected in 
	global list CONTRACT_OPTIONS
	'''
	def handle_selected_contract(self, mn, index):
		for i,v in enumerate(CONTRACT_OPTIONS):
			# this is throwing an error
			mn.entryconfigure(i, label=v)
		mn.entryconfigure(index, label=u'\u2713 '+CONTRACT_OPTIONS[index])

	'''
	@method handle_set_gas [NFO Coin Context and Manifesto Context]
	Changes the gas amount set with all transactions
	Called when "Change Gas Amount" button is clicked
	'''
	def handle_set_gas(self):
		new_gas = gas_entry.get()
		if new_gas:
			new_gas=int(new_gas)

		print('setting gas amount to '+str(new_gas))
		self.bci.set_gas(new_gas)

	'''
	@class BCInterface @method handle_new_account
	Interfaces with tkinter "New Account" button
	'''
	def handle_new_account(self):
		password = None
		while not password:
			password = simpledialog.askstring("simbel","Choose a password for your new account: ")
		print("Attempting to unlock account...")
		self.bci.web3.personal.newAccount(password)

	'''
	@class BCInterface @method handle_unlock_account
	Interfaces with tkinter "Unlock Account" button
	'''
	def handle_unlock_account(self):
		password = None
		while not password:
			password = simpledialog.askstring("simbel","Enter your Ethereum account password: ")

		self.ethereum_acc_pass=password
		self.ethereum_acc_pass = password
		self.bci.unlock_account(password)
		self.manifestointerface.unlock_account(password)
	'''
	@method handle_show_accounts 
	Updates the Account menu bar with a current list of Ethereum accounts 
	Called periodically with each clock() cycle
	'''
	def handle_show_accounts(self):
		if self.bci:
			for a in self.bci.eth_accounts:
				if a not in ACCOUNT_OPTIONS:
					ACCOUNT_OPTIONS.append(a)
					accountmenu.add_command(label=a,command=self.dynamic_account_handler(a))

	'''
	@method dynamic_account_handler
	Dynamically creates functions that are used as handlers when an Ethereum
	account is selected from the Account menu bar
	@parameter addr is an Ethereum address contained in the global list 
	ACCOUNT_OPTIONS
	'''
	def dynamic_account_handler(self,addr):
		def _function():
			index = ACCOUNT_OPTIONS.index(addr) 
			i=2
			while i < 2+len(ACCOUNT_OPTIONS):
				accountmenu.entryconfigure(i, label=ACCOUNT_OPTIONS[i-2])
				i+=1
			# when an account is selected, clear the Ethereum password from memory
			self.ethereum_acc_pass = None
			# place checkmark next to selected Ethereum address from Account menu bar
			accountmenu.entryconfigure(index+2, label=u'\u2713 '+ACCOUNT_OPTIONS[index])
			self.bci.set_account(index)

		return _function


	'''
	@method launch
	Loads the Ethereum network selected in the Home context
	Called when the "Launch" button is clicked
	@TODO (low priority) 
		currently mining occurs using the zero-indexed Ethereum account
		as the coinbase account; need to change this to allow easy changing of
		the default coinbase account
	'''
	def launch(self):
		self.ready = True
		choice = self.network_variable.get()

		if choice == NETWORK_OPTIONS[0]: #Simbel network selected
				self.network="simbel"
				print("Loading ",choice) 
				cmd = "./load_simbel.sh" 
				process = subprocess.Popen(cmd,stdin=subprocess.PIPE,stdout=subprocess.PIPE, stderr=subprocess.PIPE)
				process.stdin.write("\n".encode())
				process.stdin.write("\n".encode())
				process.stdin.close()
				print (process.stdout.read())
			
				self.bci = BCInterface(mainnet=False)
				self.fsi = FSInterface()
				self.contract_address=simbel_contract_address
				simbel.load_interface()


		if choice == NETWORK_OPTIONS[1]: #Main Ethereum network
				self.network="mainnet"
				print("Loading ",choice)
				cmd = "./load_mainnet.sh"
				process = subprocess.Popen(cmd,stdin=subprocess.PIPE,
					stdout=subprocess.PIPE, stderr=subprocess.PIPE)
				process.stdin.write("\n".encode())
				process.stdin.write("\n".encode())
				process.stdin.close()
				print (process.stdout.read())
					
				self.bci = BCInterface(mainnet=True)
				self.fsi = FSInterface()
				self.contract_address=simbel_contract_address

		messagebox.showinfo("Success", "You are connected to "+self.network+". Select a contract from the top menu bar.")
		current_network_label.config(text="You are connected to "+self.network)
		network_label.grid_remove()
		network_option.grid_remove()
		launch_button.grid_remove()
		gas_label.grid()
		set_gas_button.grid()
		gas_entry.grid()


	'''
	@method clear_screen
	Clears all frames from the GUI. Called when changing contexts
	'''
	def clear_screen(self):
		if not self.ready:
			return

		try:
			simbel.clear_canvas()
		except:
			print("simbel not defined in clear_screen()")

		gif_label.grid_remove()
		proposal_listbox.grid_remove()
		manifesto_address_label.grid_remove()
		manifesto_address_entry.grid_remove()
		new_proposal_text.grid_remove()
		new_proposal_label.grid_remove()
		new_proposal_button.grid_remove()
		vote_proposalID_label.grid_remove()
		vote_proposalID_entry.grid_remove()
		vote_label.grid_remove()
		vote_entry.grid_remove()
		vote_button.grid_remove()
		gas_label.grid_remove()
		gas_entry.grid_remove()
		set_gas_button.grid_remove()

		address_label.grid_remove()
		address_entry.grid_remove()
		balance_label.grid_remove()
		nfocoin_balance_label.grid_remove()
		buy_nfocoin_label.grid_remove()
		buy_nfocoin_entry.grid_remove()
		gas_label.grid_remove()
		gas_entry.grid_remove()
		account_label.grid_remove()
		new_account_button.grid_remove()
		unlock_account_button.grid_remove()
		network_label.grid_remove()
		network_option.grid_remove()
		launch_button.grid_remove()

		# clear frames
		top_frame.grid_remove()
		center_frame.grid_remove()
		transaction_frame.grid_remove()
		account_frame.grid_remove()
		network_frame.grid_remove()
	
	'''
	@method clock
	Updates the display. Called periodically every X seconds
	'''
	def clock(self):

		time = datetime.datetime.now().strftime("Time: %H:%M:%S")
		dt = datetime.datetime.now()
		twinpeaks.handle_show_accounts()

		if self.bci:

			if len(self.bci.eth_accounts) >0:
				address_entry.delete(0,END)
				address_entry.insert(0,self.bci.eth_accounts[self.bci.account_index])

			if not gas_entry.get():
				if self.network == "simbel":
					gas_entry.insert(0,"4000000")
				elif self.network == "mainnet":
					gas_entry.insert(0,"70000")

			if gas_entry.get():
				self.bci.set_gas(int(gas_entry.get()))

		# BOOKMARK
		try:
			simbel.update_class()
		except:
			print("simbel not yet initialized")
		if simbel.ready and dt.second%9==0:
			simbel.load_interface()
			try:
				greeting = simbel.bci.contract.call().greet_simbel(randrange(0,5))
				simbel.update_simbel_says_label(greeting)
			except:
				pass

		if simbel.ready and dt.second%60==0:

			enode = simbel.fsi.my_enode()

			if not hasattr(simbel, 'ethereum_acc_pass'):
				answer = simpledialog.askstring("Simbel","Enter your Ethereum account password: ")
				simbel.ethereum_acc_pass = answer

			try:
				simbel.bci.unlock_account(simbel.ethereum_acc_pass)
			except:
				pass
			# regikter node on blockchain - to grow network and
			# update network time
			try:
				simbel.bci.contract.transact(simbel.bci.tx).add_entity(enode)
				num_entities = simbel.bci.contract.call().get_entity_count()
				print('there are '+str(num_entities)+' entities')
			except:
				pass
		
		if simbel.ready and dt.second%30 ==0:
			print('updating peer list...')
			simbel.update_peer_list()
		if simbel.ready and dt.second%60==0:
			simbel.update_static_nodes
		if simbel.ready and dt.second%90==0:
			consensus_time = simbel.get_consensus_time()
			simbel.update_class(consensus_time)

		self.master.after(1000,self.clock)

def About():
	text = "Simbel\nInitial work: Omar Metwally\nomar.metwally@gmail.com\n\nhttps://github.com/osmode/simbel"
	messagebox.showinfo("About Simbel", text)
    
root = Tk()
root.geometry('{}x{}'.format(500, 700))

twinpeaks = TwinPeaks(root)
menubar = Menu(root)
# layout all of the main containers
root.grid_rowconfigure(1, weight=1)
root.grid_columnconfigure(0, weight=1)

# Create menu bars at the top of the screen
contractmenu = Menu(menubar)
menubar.add_cascade(label="Contract", menu=contractmenu)

accountmenu = Menu(menubar)
accountmenu.add_command(label="New Account", command=twinpeaks.handle_new_account)
accountmenu.add_separator()
menubar.add_cascade(label="Account", menu=accountmenu)

helpmenu = Menu(menubar)
menubar.add_cascade(label="Help", menu=helpmenu)
helpmenu.add_command(label="About...", command=About)

root.config(menu=menubar)

# shooting star gif
gif_path = os.getcwd()+'/images/ss.gif'
frames = [PhotoImage(file=gif_path,format="gif -index %i" %(i)) for i in range(36)]
gif_label = Label(root) #, image=frames[0])

def update(ind):

	frame = frames[ind%36]
	gif_label.configure(image=frame)
	if ind%36==0 and twinpeaks.context=="home":
		pass
		#gif_label.grid(row=1,column=0, padx=20, sticky="w")
	elif twinpeaks.context != "home" and ind%36==0:
		gif_label.grid_remove()

	ind+=1

	root.after(100,update,ind)

def on_close():
	process=subprocess.Popen("tmux kill-session -t geth".split())
	print("Quitting Simbel and killing geth...")
	#process=subprocess.Popen("tmux kill-session -t ipfs".split())
	twinpeaks.master.quit()
	print("Done.")

gif_path = os.getcwd()+'/images/ss.gif'
frames = [PhotoImage(file=gif_path,format="gif -index %i" %(i)) for i in range(36)]
gif_label = Label(root) #, image=frames[0])

'''
bg_gif_path = os.getcwd()+'/images/bg.gif'
bg_image = PhotoImage(file=bg_gif_path)
bg_label = Label(root, image=bg_image)
bg_label.place(x=0,y=0,relwidth=1,relheight=1)
'''

top_frame = Frame(root, width=1000, height=150, relief="sunken")
top_frame.grid(row=0, sticky="sew", padx=(50,10), pady=(50,10))

center_frame = Frame(root)
center_frame.grid(row=1,sticky="new", padx=(50,10) )
transaction_frame = Frame(root, width=1000, height=100,padx=40, pady=20, relief="sunken", borderwidth=2)
transaction_frame.grid(row=2,sticky="new", padx=(50,50), pady=(50,50))
transaction_frame.grid_remove()
account_frame = Frame(root, width=1000, height=100,padx=40, pady=20, relief="sunken")
account_frame.grid(row=3,sticky="ew")
account_frame.grid_remove()
network_frame = Frame(root, width=1000, height=100,padx=40, pady=20, relief="sunken",borderwidth=2)
network_frame.grid(row=4,sticky="ew")

# arrange elements within frames

## TOP FRAME 
intro_label = Label(top_frame, text=intro,font="Courier 60")
intro_label.grid(row=0)
## CENTER FRAME 
address_label = Label(center_frame, text="Your Ethereum address: ")
address_label.grid(row=1, sticky="w")
address_entry = Entry(center_frame)  
address_entry.grid(row=2)
address_entry.config(width=45)

balance_label = Label(center_frame,text="Ether Balance: " )
balance_label.grid(row=3, column=0, sticky="w", pady=10)
balance_label.grid_remove()
nfocoin_balance_label = Label(center_frame,text="NFO Coin Balance: ")
nfocoin_balance_label.grid(row=4, column=0, sticky="w",pady=10)
nfocoin_balance_label.grid_remove()

## ACCOUNT FRAMEi
account_label = Label(account_frame, text="Account: ",padx=20,pady=40)
account_label.grid(row=7,column=0)
account_label.grid_remove()

new_account_button = Button(account_frame, text="New Account", command=twinpeaks.handle_new_account)
new_account_button.grid(row=8,column=0)
new_account_button.grid_remove()
unlock_account_button = Button(account_frame, text="Unlock Account", command=twinpeaks.handle_unlock_account)
unlock_account_button.grid(row=8, column=1)
unlock_account_button.grid_remove()

network_label = Label(network_frame, text="Network: ")
network_label.grid(row=9 )
network_label.grid_remove()

network_option = OptionMenu(network_frame, twinpeaks.network_variable, *NETWORK_OPTIONS, command=None) 
network_option.grid(row=9,column=1,pady=20)

launch_button = Button(network_frame, text="Launch", command=twinpeaks.launch)
launch_button.grid(row=10, column=1)

current_network_label = Label(network_frame, text="")
current_network_label.grid(row=8,column=1,sticky='sw')

gas_label = Label(network_frame, text="Gas: ")
gas_label.grid(row=9,column=0, sticky="se")
gas_label.grid_remove()
gas_entry = Entry(network_frame)
gas_entry.grid(row=9,column=1, sticky=W)
gas_entry.grid_remove()
set_gas_button = Button(network_frame, text="Change Gas Amount",command=twinpeaks.handle_set_gas)
set_gas_button.grid(row=9,column=2,sticky=E)
set_gas_button.grid_remove()

# Simbel - the clock that synchronizes on the blockchain 
simbel = Simbel(center_frame)
simbel.creating_all_function_trigger()
simbel.create_simbel_says_label()

# handle X-ing window
root.protocol("WM_DELETE_WINDOW", on_close)
# handle quit
atexit.register(on_close)

twinpeaks.clock()
root.after(0,update,0)
root.mainloop()

