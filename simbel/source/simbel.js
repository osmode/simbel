var contract_abi=web3.eth.contract();

var contract_obj = contract_abi.new(
{
from: web3.eth.accounts[0],
data: '0x',
gas: '2000000'
}, function (e, contract) {
console.log(e, contract);
if (typeof contract.address !== 'undefined') {
console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
}
})
