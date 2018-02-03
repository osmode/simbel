import tkinter as Tkinter
import math, time, os
from bcinterface import *
from fsinterface import *
from tkinter import Label
import datetime
import time

'''
@class Simbel

My gift for Betty T
A clock that synchronizes by concensus
All my love, 
Omar M

@todo allow passing of array of frames 
'''
class Simbel:
	def __init__(self, frame):
		self.ready = False
		self.frame = frame
		self.x=150	# Center Point x  
		self.y=150	# Center Point
		self.length=75	# Stick Length
		self.creating_all_function_trigger()
		# self.peers keys are enodes
		# self.peers values are timestamps
		self.peers = {}  		

	def load_interface(self):
		self.bci = BCInterface(mainnet=False)
		self.bci.load_contract(contract_name='simbel')
		self.fsi = FSInterface()
		self.ready=True

	def create_simbel_says_label(self, text=None):
		if not hasattr(self, 'frame'): return
		if hasattr(self,'simbel_says_label'):
			return

		self.simbel_says_label = Label(self.frame, text= (text or 'Press the Launch button to connect to the Simbel network...'))
		self.simbel_says_label.grid(row=4,column=0)

	def update_simbel_says_label(self, new_text):
		if not hasattr(self, 'frame'): return
		if not hasattr(self, 'simbel_says_label'):
			self.create_simbel_says_label(self.frame, 'simbel says: '+new_text)
		self.simbel_says_label.config(text=new_text)
		self.simbel_says_label.grid()

	# Creating Trigger For Other Functions
	def creating_all_function_trigger(self):
		self.create_canvas_for_shapes()
		self.creating_background_()
		self.creating_sticks()
		return

	# Creating Background
	def creating_background_(self):
		clock_gif_path = os.getcwd()+'/images/clock2.gif'
		self.image=Tkinter.PhotoImage(file=clock_gif_path)
		self.canvas.create_image(150,150, image=self.image)
		return

	# creating Canvas
	def create_canvas_for_shapes(self):
		self.canvas=Tkinter.Canvas(self.frame, width=300, height=300 )
		self.canvas.grid(row=3,column=0)
		return

	# Creating Moving Sticks
	def creating_sticks(self):
		self.sticks=[]
		for i in range(3):
			store=self.canvas.create_line(self.x, self.y,self.x+self.length,self.y+self.length,width=2, fill='red')
			self.sticks.append(store)
		return

	def clear_canvas(self):
		self.canvas.grid_remove()
		#self.simbel_says_label.grid_remove()
		self.frame.grid_remove()

	def show_canvas(self):
		self.canvas.grid()

	# Function Need Regular Update
	def update_class(self, new_timestamp=None):
		if new_timestamp:
			dt = datetime.datetime.fromtimestamp(new_timestamp)
			now=( dt.hour, dt.minute, dt.second )
		else:
			now=time.localtime()
			t = time.strptime(str(now.tm_hour), "%H")
			hour = int(time.strftime( "%I", t ))*5
			now=(hour,now.tm_min,now.tm_sec)

		# Changing Stick Coordinates
		for n,i in enumerate(now):
			x,y=self.canvas.coords(self.sticks[n])[0:2]
			cr=[x,y]
			cr.append(self.length*math.cos(math.radians(i*6)-math.radians(90))+self.x)
			cr.append(self.length*math.sin(math.radians(i*6)-math.radians(90))+self.y)
			self.canvas.coords(self.sticks[n], tuple(cr))
		return

	'''
	@class Simbel
	@method update_peer_list
	iterate through list of entities on blockchain
	and save {enode:timestamp} in self.peers
	'''
	def update_peer_list(self):
		if not hasattr(self, 'bci'): 
			print('BCInterface object has not been initialized yet.')
			return	
		if not self.bci:
			return
		
		try:
			num_entities = self.bci.contract.call().get_entity_count()
			print('simbel found ',num_entities,' entities')
		except:
			return

		i = 0
		while i < num_entities:
			entity = self.bci.contract.call().get_row(i)
			print('entity: ', entity)
			enode = entity[0]
			timestamp = entity[1]
			self.peers[enode] = timestamp

			i+=1
		return

	'''
	@class Simbel
	@method update_static_nodes
	iterate through self.peers (enode is the dict key)
	and update static-nodes.json
	'''
	def update_static_nodes(self):
		print('updating static-nodes.json...')
		if not hasattr(self,'fsi'):
			print('FSInterface not initialized yet.')
			return
		if not self.fsi:
			return
		num_peers = len(self.peers)
		print('simbel found ',num_peers,' nodes')
		for k,v in self.peers.items():
			print('adding ',k,' to static-nodes.json...')
			self.fsi.add_static_node(k)
		return

	'''
	@class Simbel
	@method get_consensus_time
	returns a mean of all timestamps in self.peers
	'''
	def get_consensus_time(self):
		print('calculating universal consensus timestamp')
		num_peers = len(self.peers)
		timestamps = []
		for k,v in self.peers.items():
			timestamps.append(v)
		if len(timestamps)==0:
			consensus_time = time.time()
		else:
			consensus_time = sum(timestamps) / len(timestamps)
		print('Universal Consensus Time: ', consensus_time)
		return consensus_time 
		
			


