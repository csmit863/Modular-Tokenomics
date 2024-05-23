//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "src/contracts/BurnOnTx.sol";
import "src/contracts/DemurrageFee.sol";
import "src/contracts/ExecuteAfterLockup.sol";
import "src/contracts/LotterySystem.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "forge-std/console.sol";

/*
NEW IDEA: burn until total supply = x
          allow staking until total supply = y


adjustable inflation rates for InflateOnStake
    -> for InflateOnStake, can people use this function to accrue their own liquidity?
        -> yes, you could initialise the token contract by IERC20(token) and use
           .customFunc() executeAfterLockup (?)

Defining business usecases:

* incentivize participation
* ensure utility & value
* establish governance

examples of varying use cases of modular tokenomics:
redeemable token based coupons
    - simply redeem coupons using tokens, e.g. 10 tokens = 1 product
    - may want to implement some features into this token, e.g. 

event-specific tokens
    - incentivize participation during an event, but not after

accessing liquidity
    - incentivize token holders to lend their tokens
*/

contract MyToken is ERC20, BurnOnTx, Demurrage, ExecuteAfterLockup, LotterySystem {

    event contractCreated(address creator, uint totalSupply);

    address public owner;

    struct BurnSettings {
        uint256 initialBurnRate;
        uint256 initialBurnGoal;
    }
    struct DemurrageSettings {
        address taxAddress;
        uint256 demurragePeriod;
        uint256 taxAmount;
        uint256 incentiveAmount;
    }

    struct LockupSettings {
        uint256 lockupAmount;
        uint256 lockupTime;
    }

    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 _initialSupply, 
        BurnSettings memory _burnSettings,
        DemurrageSettings memory _demurrageSettings,
        LockupSettings memory _lockupSettings
        ) 
        ERC20(_name, _symbol) 
        BurnOnTx(
            _burnSettings.initialBurnRate, 
            _burnSettings.initialBurnGoal
            )
        Demurrage(
            _demurrageSettings.taxAddress, 
            _demurrageSettings.demurragePeriod, 
            _demurrageSettings.taxAmount, 
            _demurrageSettings.incentiveAmount
            )
        ExecuteAfterLockup(
            _lockupSettings.lockupAmount, 
            _lockupSettings.lockupTime
            )
        {
            _mint(msg.sender, _initialSupply*10**decimals());
            owner = msg.sender;
            emit contractCreated(msg.sender, _initialSupply*10**decimals());
        }

    // BurnOnTx
    function transfer(address to, uint256 amount) public override(BurnOnTx, ERC20) returns (bool) {
        BurnOnTx.transfer(to, amount);
        return true;
    }    
    
    function transferFrom(address from, address to, uint256 amount) public override(BurnOnTx, ERC20) returns (bool){
        BurnOnTx.transferFrom(from, to, amount);
        return true;
    }

    // ExecuteAfterLockup stuff
    function lockAndVote() public {
        // any requirements can go here
        // cast a vote?
        console.log("Vote cast");
        _lockup();
    }

    function cancelVote() public {
        //any requirements can go here
        console.log("Vote cancelled");
        _cancelLockup();
    }

    // e.g. execute a vote, requires a lock up, then complete the lock up 
    // after 1000 blocks
    function myFunction() executeAfterLockup public {
        console.log("Hello world, executed after lockup");
    }

    // DisperseOnTx stuff
    
    uint256 public buyInAmount = 100;

    function addToLottery() public {
        _addToLottery(buyInAmount);
    }

    function drawLottery() public {
        _drawLottery();
    }


}




/*

Most projects, when explaining their tokenomics, typically include
the distribution of their tokens initially, vesting periods, and finally
a projected supply graph and a release schedule of tokens.

But why stop there?

It is easy enough to implement burns on transfers, but what else can be done?

Libraries and standards exist (e.g. ERC-4626, OpenZeppelin contracts) which
allow a developer to specify things such as vesting schedules. However, for
more complex, nuanced and perhaps experimental tokenomics, there exist no
standard libraries. 

Because of this, innovation around tokenomics has somewhat stalled as, understandably,
projects are not particularly willing to program their own tokenomics components at the 
risk of exposing their protocol to security vulnerabilities. 

*/
