
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "src/contracts/ExecuteAfterLockup.sol";
import "src/contracts/DemurrageFee.sol";
import "src/contracts/BurnOnTx.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

abstract contract IFB452_Coin is ERC20, Demurrage, BurnOnTx, ExecuteAfterLockup {

    //ExecuteAfterLockup settings:
    uint256 private _lockupAmount = 100; // tokens
    uint256 private _lockupTime = 10; //blocks

    //demurrage settings:
    uint256 private _demurragePeriod = 10; // in blocks
    uint256 private _taxAmount = 500; // 500 basis points
    uint256 private _incentive = 200; // 200 basis points


    //burn on tx settings;
    uint256 private _burnRate = 100; // 100 basis points

    // will only implement a flat burn rate
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply)
    ERC20(_name, _symbol)
    Demurrage(address(1), _demurragePeriod, _taxAmount, _incentive)
    BurnOnTx(_burnRate, 0, 0)
    ExecuteAfterLockup(_lockupAmount, _lockupTime)
    {
        _mint(msg.sender, _initialSupply);
    }


    address internal voter;
    function BecomeVoter() public {
        require(voter == address(0), 'voter already taken');
        _lockup();
        voter = msg.sender;
    }
    function CancelVote() public {
        require(voter == msg.sender, 'only voter can cancel vote');
        _cancelLockup();
        voter = address(0);
    }
    function TheChosenOne() public executeAfterLockup {
        require(voter == msg.sender, 'only voter can call');
        _mint(msg.sender, 99999999); // hooray
        voter = address(0);
    }

    function transfer(address to, uint256 amount) public override(BurnOnTx, ERC20) returns (bool) {
        BurnOnTx.transfer(to, amount);
        return true;
    }    
    function transferFrom(address from, address to, uint256 amount) public override(BurnOnTx, ERC20) returns (bool){
        BurnOnTx.transferFrom(from, to, amount);
        return true;
    }
}
