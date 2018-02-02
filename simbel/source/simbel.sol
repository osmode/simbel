pragma solidity ^0.4.0;
contract Simbel {

	struct EntityStruct {

	    string enode;
	    uint timestamp;
	    bool isEntity;
	}

	mapping(address => EntityStruct) public entityStructs;
	address[] public entityList;
	
	function is_entity(address entityAddress) public constant returns(bool isIndeed) {
		return entityStructs[entityAddress].isEntity;
	   }

	function get_entity_count() public constant returns(uint entityCount) {
		return entityList.length;
	}

	function new_entity(address entityAddress, string enode) public returns(uint rowNumber) {

		if(is_entity(entityAddress)) revert();
		entityStructs[entityAddress].enode = enode;
		entityStructs[entityAddress].isEntity = true;
		entityStructs[entityAddress].timestamp = block.timestamp;
		return entityList.push(entityAddress) -1;
	}

	function update_entity_enode(address entityAddress, string enode) public returns(bool success) {
		if(!is_entity(entityAddress)) revert();
		entityStructs[entityAddress].enode = enode;
		entityStructs[entityAddress].timestamp = block.timestamp;
		return true;
	}

	address public owner;
	string[5] greetings;

	function Simbel() payable {
		owner = msg.sender;
        
		greetings[0] = "Hi, my name is Omar Metwally.";
		greetings[1] = "I am the creator of this contract.";
		greetings[2] = "I love you, Betty T!";
		greetings[3] = "Watching San Francisco from Twin Peaks...";
		greetings[4] = "Healthcare is a human right.";
	}
	
    /* Generates a random number from 0 to 10 based on the last block hash */
    function randomGen(uint seed) constant returns (uint randomNumber) {
        return(uint(sha3(block.blockhash(block.number-1), seed ))%10);
    }
	
	event NewEntity (
		address addr,
		string enode,
		uint timestamp
	);

    function add_entity(string enode) public returns(uint rowNumber) {
	if (is_entity(msg.sender)) {
		update_entity_enode(msg.sender, enode);
	} else {
		new_entity(msg.sender, enode);
	}
    } 

	// retrieve record using IPFS hash (input)
	// returns Record elements, namely id, ipfs hash, description, 
	// shared_by_fingerprint and shared_with_fingerprint
	function sender_enode() public returns (string _enode) {
	    assert(is_entity(msg.sender));
        _enode = entityStructs[msg.sender].enode;
	}
	
	function get_row(uint row) public returns (string _enode, uint _timestamp) {
		_enode = entityStructs[entityList[row]].enode;
		_timestamp = entityStructs[entityList[row]].timestamp;
	}	
	  
	function greet_simbel(uint _i) public returns (string greeting) {
		require(_i>=0);
		require(_i<greetings.length);
		return greetings[_i];
	}

}		


