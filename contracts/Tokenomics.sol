/*
implement economic functionality via interfaces/contracts/abstracts?
To implement:
abstract contract Demurrage {uint256 demurrageTime;} periodically tax tokens based on block height
abstract contract InflateOnStake {} allow tokens to be minted via a lock up mechanism, thereby causing inflation
abstract contract VestingSchedule {} creates a vesting schedule, where a set of authorised users may mint new tokens
abstract contract BurnOnTx {} Burn a portion of the transaction amount
abstract contract MintingCost{} implement a cost in ETH which must be paid in order to mint

 - Demurrage
 - Inflation
 - Lock-up
 - Staking
 - Inactivity penalty
 - Inactivity incentive
 - Supply burn
 - Exchange rate, minting cost, backing
 - Permissioned currency
 - Tax  
 - Special cases
 - Blacklisting, whitelisting
*/

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "src/contracts/BurnOnTx.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";




/*
abstract contract erc20 is IERC20 {
    function _update{}
}

abstract contract burnOnTx is ERC20 {

}

contract MyToken is BurnOnTX {
    constructor(ERC20 args, BurnOnTx args)
}

My token needs to have:

Burn Fee
Staking/InflateOnStake



*/

contract MyToken is ERC20, BurnOnTx {

    event contractCreated(address creator,uint totalSupply);

    uint8 private decimalPlaces;
    uint256 public someNumber = 10;

    constructor(
        string memory _name, 
        string memory _symbol, 
        uint _initialSupply, 
        uint8 _decimals,
        uint _initialBurnRate
        ) 
        BurnOnTx(_initialBurnRate)
        ERC20(_name, _symbol) 
        {
            decimalPlaces = _decimals;
            _mint(msg.sender, _initialSupply*10**decimals());
            emit contractCreated(msg.sender, _initialSupply*10**decimals());
        }

    function decimals() public view override returns (uint8) {
        return decimalPlaces;
    }


}

/*
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



/*
contract MyToken2 is ERC20 {
    Component1 private component1;
    uint256 public burnAmount = 20;
    function _transfer(address from, address to, uint256 value) internal virtual override {
        uint256 newValue = component1.doBurn(from, value, burnAmount);
        _update(from, to, newValue);
    }
}
*/