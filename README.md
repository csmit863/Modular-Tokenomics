# Modular-Tokenomics

## Plug-and-play components to implement tokenomics into ERC20s.

#### These contracts will facilitate the implementation of various economic mechanisms, such as inflation, demurrage, burning, transfer fees/taxes, staking, and white/blacklisting. 

#### This project has the goal of allowing rapid iteration and experimentation of token models, as well as simplifying the process of developing tokenomics, enhancing security, and introducing gas optimizations where possible.

### How to install:

#### Start a foundry project
```
$ forge init <project name>
```

#### Install OpenZeppelin contracts
```
$ forge install OpenZeppelin/openzeppelin-contracts
```

#### Install the Modular Tokenomics library
```
$ forge install rezahexe/Modular-Tokenomics
```



#### This contract implements 5 example modules:
#
### BurnOnTx
##### Take a burn fee from each transaction.
##### Has customizable variables:
#####   - Burn Rate (uint256 % value in basis points)
#####   - Burn Goal (uint256 number of tokens to be burnt)
#####   - Burn Until (uint256 block number which burning will stop after)
#
#
### DemurrageFee
##### Refer to https://en.wikipedia.org/wiki/Demurrage_(currency)
##### Basically, a tax on holding tokens which is charged periodically.
##### Has customizable variables:
#####   - Tax address (address to which demurrage fee will be sent)
#####   - Demurrage period (uint256 in blocks which defines how often charge can be incurred)
#####   - Tax amount (uint256 % value in basis points)
#####   - Incentive amount (uint256 % value in basis points)
#
#
### ExecuteAfterLockup
##### A simple yet highly customizable component that locks up tokens, unlocks tokens and provides a modifier which can be used in any function. The modifier requires that the user has completed the lockup period and then returns the tokens to the user.
#####
#####
#####
#
### InflateOnStake
##### A generalised token staking contract, designed for modularity and customizability.
#####
#####
#####

### DisperseOnTx
##### Essentially a set of functions which allow for the implementation of a lottery system where users enter a lottery, and a draw can be called. Currently utilises an INSECURE VRF. For future reference an on-chain VRF oracle will be used. The functions are internal which allows the developer to implement their own ID system, or not, depending on how they would like to address sybil resistance.
#####
#####
#####