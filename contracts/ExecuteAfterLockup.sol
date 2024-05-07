//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

abstract contract ExecuteAfterLockup is ERC20 {

    struct lockers {
        address userAddr;
        uint256 startLock;
    }

    mapping(address => lockers) public users;


    uint256 public lockupAmount; // in tokens
    uint256 public lockupTime; // measured in blocks


    constructor(uint256 _lockupAmount, uint256 _lockupTime){
        lockupAmount = _lockupAmount;
        lockupTime = _lockupTime;
    }

    event Lockup(address, uint256);
    event WithdrawLockup(address, uint256);
    event CompleteLockup(address, uint256);

    modifier executeAfterLockup(){
        require(completeLockup(), "Condition not met");
        _;
    }
    
    // could this be used to avoid demurrage? would demurrage break this?
    // demurrage cannot be claimed from address(this)
    // if demurrage and executeafterlockup are used in tandem,
    // users are incentivized to lock their tokens in this contract to avoid
    // the demurrage tax.

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

    
    function completeLockup() private returns (bool){ 
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
what if there is a burn on every transfer?
since this contract inherits from ERC20, we can use the internal
function _transfer, which means we can bypass the token burns.


Interestingly, this contract is a little bit tricky when trying to make it work
with Demurrage.sol (and BurnOnTx). If the Demurrage and ExecuteAfterLockup contracts are used
in tandem, then the rules of Demurrage.sol dictate that any user can 'tax' this
address and claim the tokens that are locked up here. Then, when users go to
cancel their lockup or complete their lockup, the address will not have enough
tokens to compensate all users.



One way to make it compatible would actually be to burn the tokens on lockup,
and mint them once the lockup period is complete.

This way, since the tokens have been burned, they would not be able to be taxed
as they do not 'exist'. However, once the user completes their lockup or cancels
their lockup, they will have their tokens back.




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