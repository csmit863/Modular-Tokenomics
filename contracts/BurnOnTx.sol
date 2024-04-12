//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

abstract contract BurnOnTx { 
    
    uint256 public burnRate;

    constructor(uint256 _burnRate) {
        burnRate = _burnRate;
    }

    //burnrate on every tx
    
    function _update(address from, address to, uint256 value) internal virtual {
        uint256 sendAmount = value - burnRate;

        // Perform the burn by decreasing the balance of `from` by `burnAmount`
        // You would need a function similar to _burn that just reduces balance without emitting a Transfer event
        // since _burn might not be suitable if it emits Transfer event to address(0).
        //if (burnRate > 0) {
        //    _burn(from, burnRate);
        //}

        // Now, update balances as per the modified amount
        super._update(from, to, sendAmount);
    }
    
    function setBurnRate(uint256 _newRate) public {
        // Add your access control logic here (e.g., onlyOwner)
        burnRate = _newRate;
    }
    
} //modifies transfer function to burn tokens on every tx based on a burnrate
