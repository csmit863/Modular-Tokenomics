//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

abstract contract BurnOnTx is ERC20 {
    uint256 public burnRate;

    constructor(uint256 _burnRate){
        burnRate = _burnRate;
    }

    function setBurnRate(uint256 _newRate) public {
        // Add your access control logic here (e.g., onlyOwner)
        burnRate = _newRate;
    }
    
    function transfer(address to, uint256 value) public override virtual returns (bool) {        
        uint256 newValue = value - burnRate;
        _burn(msg.sender, burnRate);
        return super.transfer(to, newValue);
    }
}