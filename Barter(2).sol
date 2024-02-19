pragma solidity ^0.8.0;
///SPDX-License-Identifier: MIT
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/audit/2023-03/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/utils/Address.sol";

contract Escrow is Ownable {
    using Address for address payable;
    mapping(address => uint256) private _deposits;
    mapping(address => bool) private _handshake;
    address payable[] private barterparties;
    address [] handshakeattempts;
    bool verify = true;

modifier handshook{
    require(_handshake[barterparties[0]] == true);
    _;
    require(_handshake[barterparties[1]] == true);
    _;
}
modifier onlyOnce {
        require(barterparties.length < 2);
        _;
    }
modifier limithandshake{
    require(handshakeattempts.length < 6);
    _;
}

    receive() external payable onlyOnce{
        uint256 amount = msg.value;
        _deposits[msg.sender] += amount;
        barterparties.push(payable(msg.sender));
}
    function withdraw() external onlyOwner handshook {
        uint256 payment1 = _deposits[barterparties[0]];
        uint256 payment2 = _deposits[barterparties[1]];
        _deposits[barterparties[0]] = 0;
        _deposits[barterparties[1]] = 0; 
        barterparties[0].transfer(payment1);
        barterparties[1].transfer(payment2);
    }

    function handshake(address _addy) external limithandshake onlyOwner{
        _handshake[_addy] = true; 
        handshakeattempts.push(_addy);
    }

    function verifycontract() view external onlyOwner returns(bool){
        return verify;
    }

    function clearhandshake() external onlyOwner{
        delete handshakeattempts;
    }
}