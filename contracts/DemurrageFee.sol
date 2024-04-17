//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Demurrage {
    //ERC20 private erc20;
    address public taxAddress;
    struct addresses {
        address holderAddress;
        uint256 lastBlockTimeClaimed;
    }

    mapping(address => addresses) public addressInfo;

    /*constructor(ERC20 _token){
        erc20 = _token;
    }*/
    
    function claimDemurrageFee(address claimFrom) public {
        require(claimFrom != address(0), "Cannot claim from 0 address");
        require(claimFrom != msg.sender, "Cannot claim from own address");
        require(claimFrom.balance > 0, "Nothing to claim, balance is 0");
        require(block.timestamp - addressInfo[claimFrom].lastBlockTimeClaimed >= 1000, "Cannot claim fee, too early");
        uint256 claimFromBalance = claimFrom.balance;
        //erc20._update(claimFrom, taxAddress, claimFromBalance/20 /* 5% */);
        //erc20._update(claimFrom, msg.sender, claimFromBalance/100 /* 1% */);
    }
}
