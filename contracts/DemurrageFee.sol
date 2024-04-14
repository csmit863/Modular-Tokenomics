//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Demurrage {
    ERC20 private erc20;
    address public taxAddress;
    struct public addresses {
        address addy,
        uint256 lastBlockTimeClaimed
    }
    function claimDemurrageFee(address claimFrom) public {
        require(claimFrom != address(0), "Cannot claim from 0 address");
        require(claimFrom.balance > 0, "Nothing to claim, balance is 0");
        require(block.timestamp - addresses[claimFrom].lastBlockTimeClaimed >= 1000, "Cannot claim fee, too early");
        uint256 claimFromBalance = claimFrom.balance;
        erc20._update(claimFrom, taxAddress, claimFromBalance/20 /* 5% */);
        erc20._update(claimFrom, msg.sender, claimFromBalance/100 /* 5% */);
    }
}
