// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Token.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IReceiver {
    function receiveTokens(address tokenAddress, uint256 amount) external;
}

contract FlashLoan {
    using SafeMath for uint256;

    Token public token;
    uint256 public poolBalance;

    constructor(address _tokenAddress) {
        token = Token(_tokenAddress);
    }

    function despositTokens(uint256 _amount) external {
        require(_amount > 0, "Must deposit at least one token");
        token.transferFrom(msg.sender, address(this), _amount);
        poolBalance = poolBalance.add(_amount);
    }

    function flashLoan(uint256 _borrowAmount) external {
        require(_borrowAmount > 0, "Must borrow at least one token");
        
        uint256 balanceBefore = token.balanceOf(address(this));
        require(balanceBefore >= _borrowAmount, "Not enough tokens in the pool");

        // Ensured by the protocol via the 'depositTokens' function
        assert(poolBalance == balanceBefore);

        // Send tokens to the receiver
        token.transfer(msg.sender, _borrowAmount);

        // Use loan, Get paid back
        IReceiver(msg.sender).receiveTokens(address(token), _borrowAmount);

        // Ensure loan paid back
        uint256 balanceAfter = token.balanceOf(address(this));
        require(balanceAfter >= balanceBefore, "Flash loan has not been paid back");

    }
}