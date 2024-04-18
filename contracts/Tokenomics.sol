//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "src/contracts/BurnOnTx.sol";
import "src/contracts/DemurrageFee.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract MyToken is ERC20, BurnOnTx, Demurrage {

    event contractCreated(address creator,uint totalSupply);

    uint8 private decimalPlaces;
    uint256 public someNumber = 10;
    address public owner;

    constructor(
        string memory _name, 
        string memory _symbol, 
        uint _initialSupply, 
        uint8 _decimals,
        uint _initialBurnRate,
        address taxAddress
        ) 
        BurnOnTx(_initialBurnRate)
        ERC20(_name, _symbol) 
        Demurrage(taxAddress)
        {
            decimalPlaces = _decimals;
            _mint(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, _initialSupply*10**decimals()/2);
            _mint(0x70997970C51812dc3A010C7d01b50e0d17dc79C8, _initialSupply*10**decimals()/2);
            owner = msg.sender;
            emit contractCreated(msg.sender, _initialSupply*10**decimals());
        }

    function decimals() public view override returns (uint8) {
        return decimalPlaces;
    }
}

/*
inflate on stake (ERC20 token)
stake(token)
mint(token)
*/

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