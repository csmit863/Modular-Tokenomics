//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

/*

A lottery system to incentivize transactions?

Every transaction charges a tax, which is added to a prize pool.
Every x blocks the contents of the prize pool will be distributed
to users who transacted the token.

The money doesnt lose/gain value, but there is a benefit to users
exchanging the token as much as possible.

Has a very high sybil attack risk.

Different system? Or impose ID system?
modifier isParticipant
    require(valid_ID)
    _;

*/

