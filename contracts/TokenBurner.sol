//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library TokenBurner {

    struct BurnData {
        uint256 burnRate;
        uint256 burnGoal;
        uint256 totalBurnt;
    }

    uint256 private constant PRECISION = 10**18;

    function calculateBurnAmount(BurnData storage data, uint256 value) internal view returns (uint256 valueToBurn) {
        require(value > 0, "Cannot transfer amount of 0");
        // calculate the value to burn based on burn rate.
        valueToBurn = (value * data.burnRate*PRECISION/100/100) / PRECISION; 

        // check if a burnGoal has been set, and check the burnGoal has not been reached
        if (data.burnGoal > 0 && data.totalBurnt < data.burnGoal){

            // Burn at least one token if rounding causes zero
            if (valueToBurn == 0 && data.totalBurnt+1 <= data.burnGoal) {
                valueToBurn = 1; 
            }

            // Burn tokens up to the burn goal but not beyond
            if (data.totalBurnt+valueToBurn > data.burnGoal) {
                valueToBurn = data.burnGoal-data.totalBurnt; 
            }

        } 

        // if the burnGoal is 0 do a regular burn 
        return valueToBurn;
    }
}
