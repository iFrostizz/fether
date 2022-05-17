// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/math/SafeMath.sol';

contract Fallback {

  using SafeMath for uint256;
  mapping(address => uint) public contributions;
  address payable public owner;

  constructor() {
    owner = payable(msg.sender);
    contributions[msg.sender] = 1000 * (1 ether);
  }

  modifier onlyOwner {
        require(
            payable(msg.sender) == owner,
            "caller is not the owner"
        );
        _;
    }

  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[payable(msg.sender)] += msg.value;
    if(contributions[payable(msg.sender)] > contributions[owner]) {
      owner = payable(msg.sender);
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[payable(msg.sender)];
  }

  function withdraw() public onlyOwner {
    owner.transfer(payable(this).balance);
  }

  receive() external payable {
    require(msg.value > 0 && contributions[payable(msg.sender)] > 0);
    owner = payable(msg.sender);
  }
}

