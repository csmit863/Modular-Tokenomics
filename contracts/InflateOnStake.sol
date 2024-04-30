
/*
What is staking? What is inflation?

Inflation (in tokenomics) is the increase of the token's supply via minting.

Staking is when tokens are deposited into a contract for a determined amount of time, afterwards a reward is issued to the staker.

Why stake?
 - Governance: 
 - Liquidity:
 - Incentivize utilisation of currency
 - Encourage long-term holding

How would this contract be used?
As it stands, its just "deposit and mint new tokens" with no clear purpose of the token.
You should allow this functionality to be utilised in other parts of the contract.

For example, require that a user has staked tokens, and if they have, they have voting
rights for some other part of the protocol based on their stake.

e.g.
inflateOnStake.getBalanceOf(address(this))
inflateOnStake.getLastUpdated(address(this))


Start with a basic stake + mint contract where a depositor can accrue rewards
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

abstract contract InflateOnStake {

    /*
    using SafeERC20 for IERC20;
    IERC20 public immutable token;

    constructor(IERC20 _token){
        token = _token;
    }
    // The constructor now assigns the token in our contract. 
    // We have made this immutable to ensure that it can not be changed in the future.

    mapping(address => uint) public balanceOf;
    mapping(address => uint) public lastUpdated;

    function depositStake(uint256 amountToStake) external {
    }

    function totalRewards() external view returns (uint){
    }

    // from hackernoon tutorial https://hackernoon.com/how-to-implement-a-stake-and-reward-contract-in-solidity
    function _stake(address user, uint256 amount) internal {
        _updateUserRewards(user);
        totalStaked += amount;
        userStake[user] += amount;
        stakingToken.safeTransferFrom(user, address(this), amount);
        emit Staked(user, amount);
    }

    function _unstake(address user, uint256 amount) internal {
        _updateUserRewards(user);
        totalStaked -= amount;
        userStake[user] -= amount;
        stakingToken.safeTransfer(user, amount);
        emit Unstaked(user, amount);
    }
    
    function _claim(address user, uint256 amount) internal {
        uint256 rewardsAvailable = _updateUserRewards(msg.sender).accumulated;
        accumulatedRewards[user].accumulated = (rewardsAvailable - amount).u128();

        rewardTokens.safeTransfer(user, amount);
        emit Claimed(user, amount);
    }

    // function to stake tokens
    // function to mint tokens
    */
}

