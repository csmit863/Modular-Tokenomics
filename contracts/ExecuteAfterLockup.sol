//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

abstract contract ExecuteAfterLockup is ERC20 {

    struct lockers {
        address userAddr;
        uint256 startLock;
    }


    mapping(address => lockers) public users;
    uint256 public lockupAmount = 100;
    uint256 public lockupTime = 1000;

    // what if there is a burn on every transfer?
    // since this contract inherits from ERC20, we can use the internal
    // function _transfer, which means we can bypass the token burns.

    event Lockup(address, uint256);
    event WithdrawLockup(address, uint256);
    event CompleteLockup(address, uint256);

    uint256 num1 = 1;

    modifier executeAfterLockup(){
        require(completeLockup(), "Condition not met");
        _;
    }

    function lockup() public {
        require(users[msg.sender].userAddr != msg.sender, "Already locked up");
        approve(msg.sender, lockupAmount);
        _transfer(msg.sender, address(this), lockupAmount);
        users[msg.sender].userAddr = msg.sender;
        users[msg.sender].startLock = block.number;
        emit Lockup(msg.sender, lockupAmount);
    }

    function cancelLockup() public {
        require(users[msg.sender].userAddr == msg.sender, "Nothing to cancel");
        _transfer(address(this), msg.sender, lockupAmount);
        users[msg.sender].userAddr = address(0);
        emit WithdrawLockup(msg.sender, lockupAmount);
    }

    
    function completeLockup() public returns (bool){
        require(users[msg.sender].userAddr != address(0), "Must lockup tokens");
        if(block.number-1000 >= users[msg.sender].startLock){
            // if user has completed stake
            _transfer(address(this), msg.sender, lockupAmount);
            users[msg.sender].userAddr = address(0);
            emit CompleteLockup(msg.sender, lockupAmount);
            return true;
        } else {
            // if user has not completed stake
            revert("User has not completed stake");
        }
        
    }
    
}


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


why?
ensure users are committed to the project before they trigger some action
incentivize users to provide liquidity for whatever reason

*/