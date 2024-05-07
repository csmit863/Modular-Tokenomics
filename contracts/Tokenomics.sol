//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "src/contracts/BurnOnTx.sol";
import "src/contracts/DemurrageFee.sol";
import "src/contracts/ExecuteAfterLockup.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

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

accessing liquidity{x for x in U if 12 % x == 0}

    - incentivize token holders to lend their tokens

*/



contract MyToken is ERC20, BurnOnTx, Demurrage, ExecuteAfterLockup {

    event contractCreated(address creator, uint totalSupply);

    address public owner;

    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 _initialSupply, 
        uint256 _initialBurnRate,
        uint256 _initialBurnGoal,
        address taxAddress,
        uint256 _lockupAmount,
        uint256 _lockupTime
        ) 
        ERC20(_name, _symbol) 
        BurnOnTx(_initialBurnRate, _initialBurnGoal)
        Demurrage(taxAddress)
        ExecuteAfterLockup(_lockupAmount, _lockupTime)
        {
            _mint(msg.sender, _initialSupply*10**decimals());
            owner = msg.sender;
            emit contractCreated(msg.sender, _initialSupply*10**decimals());
        }

    function transfer(address to, uint256 amount) public override(BurnOnTx, ERC20) returns (bool) {
        BurnOnTx.transfer(to, amount);
        return true;
    }    
    
    function transferFrom(address from, address to, uint256 amount) public override(BurnOnTx, ERC20) returns (bool){
        BurnOnTx.transferFrom(from, to, amount);
        return true;
    }
    
    function myFunction() executeAfterLockup public returns (string memory){
        return "Hello world";
    }

}




/*

constructor () {
    token = ERC20(0x...);

    
Ideal final state:
contract CallumCoin is ERC20, BurnOnTx, InflateWithStake, DemurrageFee {

    constructor(
        *args for components*
    ) ERC20() BurnOnTx() InflateWithStake() DemurrageFee()
    {
        *things to execute on start*
        
    }

    function mySpecialFunction() public onlyOwner {
        burnOnTx.activated = False;
    }
}

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
