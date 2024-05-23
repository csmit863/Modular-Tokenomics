//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "forge-std/console.sol";

/*

Two challenges:

Introducing sybil resistance
 - ID system with internal func implementation
Generating a truly random number
 - (TEMPORARY, NOT SECURE) using hash function + prevrandao (difficulty), for future reference use on chain oracle for maximum randomness.
 - https://blog.chain.link/random-number-generation-solidity/
 - Chainlink VRF
*/

// lottery system with multiple tickets increasing the odds of winning

abstract contract LotterySystem is ERC20 {
    
    constructor(){
        lotteryPool = 0;
    }

    uint256 lotteryPool;

    address[] private participants;

    function getRandomIndex() private view returns (uint256){
        // FOR FUTURE REFERENCE: CALL CHAINLINK VRF
        uint256 randomIndex = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, participants.length))) % participants.length;
        console.log(randomIndex);
        return randomIndex;
    }

    function _selectRandomWinner() private view returns (address){ 
        require(participants.length > 0, "No participants in the lottery");
        uint256 randomIndex = getRandomIndex(); 
        return participants[randomIndex];
    }

    function _addToLottery(uint256 amount) internal {
        _transfer(msg.sender, address(this), amount);
        participants.push(msg.sender);
        lotteryPool += amount;
    }

    function _drawLottery() internal {
        address winner = _selectRandomWinner();
        console.log("Winner:", winner);
        _transfer(address(this), winner, lotteryPool);
        lotteryPool = 0;
        delete participants;
    }

}

// https://codedamn.com/news/solidity/how-to-generate-random-numbers-in-solidity



/*

A lottery system to incentivize transactions?

Every transaction charges a tax, which is added to a prize pool.
Every x blocks the contents of the prize pool will be distributed
to users who transacted the token.

The money doesnt lose/gain value, but there is a benefit to users
exchanging the token. 

Has a very high sybil attack risk.

Different system? Or impose ID system?
Impose ID system through implementing internal functions in inherited contract.
For example:

function myFunc() public {
    require(validID);
    _addToLottery();
}


Future considerations:

Limiting lottery entrants
    bool limitEntrants = false;

    modifier limitEntrant() {
        if (limitEntrants) {
            require(participants[msg.sender] == address(0), "Already in the lottery");
            participants.push(msg.sender);
            hasParticipated[msg.sender] = true; 
        }
        _;
    }
    function _addToLottery(uint256 amount) internal limitEntrant {
        ...
    }


*/
