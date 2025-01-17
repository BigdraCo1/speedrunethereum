// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  event Stake(address _address, uint256 _amount);

  mapping ( address => uint256 ) public balances;
  uint256 public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 30 seconds;

  ExampleExternalContract public exampleExternalContract;

  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // (Make sure to add a `Stake(address,uint256)` event and emit it for the frontend `All Stakings` tab to display)
  function stake() public payable{
    require(msg.value > 0, "No Brokie");
    balances[msg.sender] = msg.value;
    emit Stake(msg.sender, msg.value);
  }


  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
  function execute() external payable {
    require(block.timestamp > deadline, "Deadline has not passed yet");
    if (address(this).balance >= threshold) {
     balances[msg.sender] = address(this).balance; 
    exampleExternalContract.complete{value: address(this).balance}();
    }
  }

  // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
  function withdraw() public payable {
    require(address(this).balance < threshold, "Threshold not met");
    payable(msg.sender).transfer(address(this).balance);
  }

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft()  public view returns (uint256) {
    if (block.timestamp < deadline) {
      return deadline - block.timestamp;
    }
    return 0;
  }

  // Add the `receive()` special function that receives eth and calls stake()
  receive() external payable {
    require(msg.value > 0, "No Brokie");
    stake();
    balances[msg.sender] += address(this).balance;
  }
}
