//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

abstract contract Demurrage is ERC20 {

    address public taxAddress;
    struct addresses {
        address holderAddress;
        uint256 lastBlockTimeClaimed;
    }
    uint256 demurragePeriod;

    event DemurrageClaimed(address holder, address claimer, uint amountClaimed);

    mapping(address => addresses) public addressInfo;

    constructor(address _taxAddress, uint256 _demurragePeriod){
        taxAddress = _taxAddress;
        demurragePeriod = _demurragePeriod;
    }

    function claimDemurrageFee(address claimFrom) public {
        require(claimFrom != address(0), "Cannot claim from 0 address");
        require(claimFrom != address(this), "Cannot claim from contract address");
        require(balanceOf(claimFrom) > 0, "Nothing to claim, balance is 0");
        require(block.number - addressInfo[claimFrom].lastBlockTimeClaimed >= demurragePeriod, "Cannot claim fee, too early"); 
        uint256 claimFromBalance = balanceOf(claimFrom);
        _transfer(claimFrom, taxAddress, claimFromBalance/20 /* 5% */); // create % represented fee as variable set in constructor
        _transfer(claimFrom, msg.sender, claimFromBalance/100 /* 1% */); // create % represented fee as variable set in constructor
        addressInfo[claimFrom].lastBlockTimeClaimed = block.number;
        emit DemurrageClaimed(claimFrom, msg.sender, claimFromBalance/20+claimFromBalance/100);
    }
}

/*
explanation:

Demurrage fees were a cost or tax imposed on currencies during the early 20th century to disincentivize hoarding of money
and incentivize spending. The way it worked was currency was only valid if it was stamped, and once it was stamped it 
would lose some percentage of its value, e.g. 1%. This is different to inflation, where new currency is circulated
thus diluting the value. Inflation can result in imprecise reduction in purchasing power, whereas demurrage reduces 
purchasing power through fixed regular fees. 

Prosperity certificates were a system introduced in Alberta during the Great Depression to incentivize spending. 
Hoarding of certificates was disincentivized by the holder requiring to affix a stamp to their certificate in
order to maintain their validity. However, since they were physical notes, there was an inconvenience in having 
to affix stamps constantly, the stamps often fell off, and the certificates were not often accepted as tender.
For these reasons, while initially successful in increasing the velocity of the money, they became unpopular
and the program was cancelled after a year.

John Maynard Keynes argued against the use of demurrage fees as it could easily be avoided by utilizing competing
currencies, therefore inflation would be a preferred alternative. However, on blockchains, we have the ability 
to program in the rules and make them impossible to side-step. Since we are using a digital currency, we can also 
avoid the issues of physical notes.

Initially, the contract was going to be designed to collect a demurrage fee from all holders of the token. However,
doing this in one transaction would be impractical as we would have to store a list of all token holders which is 
not done by default with ERC20. On top of this, the gas fee to do so would be enormous.

Instead, we have opted for an alternate solution. A struct of addresses and block numbers will be maintained,
and a mapping will be used to link addresses to the block numbers. A demurrage fee will be permitted to be 
claimed by anyone, so long as a specified number of blocks has elapsed since the address was last charged.
In order to ensure the demurrage fee is actually implemented, a small incentive will be provided to the
caller of the function, in tokens, to cover for any potential gas fees. When the function is called,
the caller will recieve their incentive from the address's balance, and another portion will be transferred
to a tax address which will collect the demurrage fees.


*/