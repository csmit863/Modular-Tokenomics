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

    uint256 public someNumber = 10;
    address public owner;

    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 _initialSupply, 
        uint256 _initialBurnRate,
        uint256 _initialBurnGoal,
        address taxAddress
        ) 
        ERC20(_name, _symbol) 
        BurnOnTx(_initialBurnRate, _initialBurnGoal)
        Demurrage(taxAddress)
        
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

    // function myFuncWithCustomLockup() executeAfterLockup(params) publix view {}
    
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
*/
