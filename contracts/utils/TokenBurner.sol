//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "forge-std/console.sol";

library TokenBurner {

    struct BurnData {
        uint256 burnRate;
        uint256 burnGoal;
        uint256 burnUntil;
        uint256 totalBurnt;
    }

    uint256 private constant PRECISION = 10**18;

    function _calculateBurnAmount(BurnData storage data, uint256 value) internal view returns (uint256 valueToBurn) {
        require(value > 0, "Cannot transfer amount of 0");
        // calculate the value to burn based on burn rate.
        
        uint256 _burnGoal = data.burnGoal;
        uint256 _totalBurnt = data.totalBurnt;
        uint256 _burnUntil = data.burnUntil;
        uint256 _burnRate = data.burnRate;
        valueToBurn = (value * _burnRate*PRECISION/100/100) / PRECISION; 

        // check if a burnGoal has been set, and check the burnGoal has not been reached, and that burnUntil has not been reached or that it is non zero
        if ((valueToBurn==0) || (_burnGoal > 0 && _totalBurnt < _burnGoal)){
            // Burn at least one token if rounding causes zero
            if ((valueToBurn == 0 && _totalBurnt+1 <= _burnGoal) || (_burnGoal == 0)) {
                valueToBurn = 1; 
            }

            // Burn tokens up to the burn goal but not beyond
            if ((_burnGoal > 0) && (_totalBurnt+valueToBurn > _burnGoal)) {
                valueToBurn = _burnGoal-_totalBurnt; 
            }

        } 

        if (block.number > _burnUntil && _burnUntil > 0){
            valueToBurn = 0;
        } 

        // if the burnGoal is 0 do a regular burn 

        return valueToBurn;
    }
}
