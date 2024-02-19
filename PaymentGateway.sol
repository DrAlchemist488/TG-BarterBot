pragma solidity ^0.8.0;
///SPDX-License-Identifier: MIT

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/audit/2023-03/contracts/finance/PaymentSplitter.sol";

contract PaymentGateway is PaymentSplitter {
    constructor(address[] memory payees, uint256[] memory shares_) PaymentSplitter(payees, shares_) payable {}
    
    receive() external override payable{
        require(msg.value >= 1 ether);
    }


}