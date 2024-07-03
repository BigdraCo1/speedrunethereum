pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) Ownable() {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    require(msg.value > 0, "It should be greater than 0");
    uint256 k = msg.value * tokensPerEth;
    yourToken.transfer(msg.sender, k);
    emit BuyTokens(msg.sender, msg.value, k);
}

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    uint256 balance = address(this).balance;
    require( balance > 0, 'No ETH here');
    payable(msg.sender).transfer(balance);
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public {
    require(_amount < 1000 * (10 ** 18), "Too Rich");
    require(_amount > 0, "Brokie");
    yourToken.approve(msg.sender, _amount);
    uint256 _eth = _amount / tokensPerEth;
    yourToken.transferFrom(msg.sender, address(this), _amount);
    payable(msg.sender).transfer(_eth);
  }
}
