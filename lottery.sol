//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.9.0;

contract Lottery {

//dynamic array 
//payable: you can transfer money to these :Players
address payable[] public players;
//WHY Manager cant recv payment : manager running the lottery not participating
address public manager;

//run once when contract is deployed
//so first one to interact with 
constructor() {
    manager = msg.sender;
    //payable is the address to whom we can pay
    //we need to cast it due to inheritance requirement

    //challenge 2
    //manager can participate in lottery 
    players.push(payable(manager));
}

//reciving money? 
//by interacting with smart contracts
receive () payable external {
//0.1 eth = additional money one pay
//limit is 0.1 eth (entrance fee to become part of lottery)
require(msg.value == 0.1 ether);    
players.push(payable(msg.sender));

}
modifier onlyManager {
    require(msg.sender == manager);
    _;
}

//to know current status of lottery
function getBalance() public view returns (uint) {
   //condition that only manager can use this function
   //msg.sender is the address of person currrently interacting with contract
   //require(msg.sender == manager) [commented because we generalized it using modifier]

   return address(this).balance;
}

//randomly selects winner of lottery
//function that returns random participant number number

//view: not changing anything to blockchain
function random() internal view returns(uint) {
      return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp,players.length)));
}

//USING MODIFIER: only manager can pick winner : if we remove it then anyone can pick the winner
function pickWinner() public onlyManager {
       
       require(players.length >= 10);

       uint r = random();
       address payable winner; 
       uint index = r % players.length;
       winner = players[index];
       //sending money to winner
       winner.transfer(getBalance());



}
