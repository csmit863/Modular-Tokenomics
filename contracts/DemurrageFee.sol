//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

abstract contract Demurrage is ERC20 {
    address public taxAddress;
    struct addresses {
        address holderAddress;
        uint256 lastBlockTimeClaimed;
    }

    event DemurrageClaimed(address holder, address claimer, uint amountClaimed);

    mapping(address => addresses) public addressInfo;

    constructor(address _taxAddress){
        taxAddress = _taxAddress;
    }

    function claimDemurrageFee(address claimFrom) public {
        require(claimFrom != address(0), "Cannot claim from 0 address");
        require(claimFrom != msg.sender, "Cannot claim from own address");
        require(balanceOf(claimFrom) > 0, "Nothing to claim, balance is 0");
        require(block.number - addressInfo[claimFrom].lastBlockTimeClaimed >= 1000, "Cannot claim fee, too early");
        uint256 claimFromBalance = balanceOf(claimFrom);
        _update(claimFrom, taxAddress, claimFromBalance/20 /* 5% */);
        _update(claimFrom, msg.sender, claimFromBalance/100 /* 1% */);
        addressInfo[claimFrom].lastBlockTimeClaimed = block.number;
        emit DemurrageClaimed(claimFrom, msg.sender, claimFromBalance/20+claimFromBalance/100);
    }
}
