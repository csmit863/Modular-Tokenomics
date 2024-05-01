//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


/* 
create a function which requires users to lock up tokens
for some amount of time. 
After the lock up time has completed, users can call an execute
function which will be able to cause other programs to execute.

function lockup()
return true

function executeAfterLockup()
    checkLockupCompleted
    (custom functionality)


*/

abstract contract ExecuteAfterLockup {
    uint256 num1 = 1;

    modifier executeAfterLockup(){
        require(helloo(), "Condition not met");
        _;
    }
    
    function helloo() public view returns (bool){
        if(num1 == 1){
            return true;
        } else {
            return false;
        }
    }
    
}