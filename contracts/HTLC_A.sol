// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract HTLC_A {
  uint public startTime;
  uint public lockTime = 100000 seconds; // should be different for Alice and Bob
  string public secret; // wonderland 
  bytes32 public hash = 0x21dbd800819ce1aaf1563e87c1e50baa74931c8afd691ba6397222d682184241;
  address public recipient;
  address public owner; 
  uint public amount; 
  IERC20 public token;

  constructor(address _recipient, address _token, uint _amount) { 
    recipient = _recipient;
    owner = msg.sender; 
    amount = _amount;
    token = IERC20(_token);
  } 

  function fund() external {
    startTime = block.timestamp;
    token.transferFrom(msg.sender, address(this), amount);
  }

  function withdraw(string memory _secret) external { 
    require(keccak256(abi.encodePacked(_secret)) == hash, 'wrong secret');
    secret = _secret; 
    token.transfer(recipient, amount); 
  } 

  function refund() external { 
    require(block.timestamp > startTime + lockTime, 'too early');
    token.transfer(owner, amount); 
  } 
}
