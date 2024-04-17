//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

abstract contract BurnOnTx {
    // burn tokens
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
        //erc20._burn(from, burnAmount);
        return newValue;
    }
}