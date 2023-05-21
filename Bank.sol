// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Bank {
    address public admin;

    mapping(address=>uint) public balances;

    constructor() {
        // set deployer of contract as admin
        admin = msg.sender;
    }


    // necessary modifiers for contract
    modifier onlyAdmin() {
        require(msg.sender == admin, "Not the admin");
        _;
    }

    modifier validateBalance(uint _amount){
        require(_amount <= balances[msg.sender], "Insufficient funds");
        _;
    }

    // function to show address of admin
    function showAdmin () public view returns (address){
        return admin;
    }

    // function to deposit and track balance of depositor
    function deposit ()  public payable {
        balances[msg.sender] += msg.value / 1000000000000000000;
    }

    // function to withdraw funds
    // only depositors can withdraw
    function withdraw (uint _amount) public validateBalance(_amount) {
        (bool success, ) =  msg.sender.call{value: (_amount * 1000000000000000000)}("");
        require(success, "Failed to withdraw Ether");
        balances[msg.sender] -= _amount;
    }

    // function returns balance of user
    function showBalance() public view returns (uint){
        return balances[msg.sender];
    }

    // function to view amount of ETH in the contract
    function getContractBalance() public onlyAdmin view returns (uint256) {
        return address(this).balance / 1000000000000000000;
    }

    // function to withdraw all funds by the admin
    function withdrawAll() public onlyAdmin {
        (bool success, ) =  msg.sender.call{value: address(this).balance}("");
        require(success, "Failed to send Ether");
    }

}
