//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";


contract BurnOnTx {
    // burn tokens
    ERC20 private erc20;
    uint256 public burnRate;
    constructor(uint256 _burnRate) {
        burnRate = _burnRate;
    }
    
    function setBurnRate(uint256 _newRate) public {
        // Add your access control logic here (e.g., onlyOwner)
        burnRate = _newRate;
    }

    function doBurn(address from, uint256 value, uint256 burnAmount) internal virtual returns (uint256) {
        uint256 newValue = value - burnAmount;
        erc20._burn(from, burnAmount);
        return newValue;
    }
}