// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.5;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

import '../interfaces/IPeripheryPayments.sol';
import '../interfaces/external/IWIP9.sol';

import '../libraries/TransferHelper.sol';

import './PeripheryImmutableState.sol';

abstract contract PeripheryPayments is WIPeripheryPayments, PeripheryImmutableState {
    receive() external payable {
        require(msg.sender == WIP9, 'Not WIP9');
    }

    /// @inheritdoc WIPeripheryPayments
    function unwrapWIP9(uint256 amountMinimum, address recipient) public payable override {
        uint256 balanceWIP9 = IWIP9(WIP9).balanceOf(address(this));
        require(balanceWIP9 >= amountMinimum, 'Insufficient WIP9');

        if (balanceWIP9 > 0) {
            IWIP9(WIP9).withdraw(balanceWIP9);
            TransferHelper.safeTransferETH(recipient, balanceWIP9);
        }
    }

    /// @inheritdoc WIPeripheryPayments
    function sweepToken(
        address token,
        uint256 amountMinimum,
        address recipient
    ) public payable override {
        uint256 balanceToken = IERC20(token).balanceOf(address(this));
        require(balanceToken >= amountMinimum, 'Insufficient token');

        if (balanceToken > 0) {
            TransferHelper.safeTransfer(token, recipient, balanceToken);
        }
    }

    /// @inheritdoc WIPeripheryPayments
    function refundETH() external payable override {
        if (address(this).balance > 0) TransferHelper.safeTransferETH(msg.sender, address(this).balance);
    }

    /// @param token The token to pay
    /// @param payer The entity that must pay
    /// @param recipient The entity that will receive payment
    /// @param value The amount to pay
    function pay(
        address token,
        address payer,
        address recipient,
        uint256 value
    ) internal {
        if (token == WIP9 && address(this).balance >= value) {
            // pay with WIP9
            IWIP9(WIP9).deposit{value: value}(); // wrap only what is needed to pay
            IWIP9(WIP9).transfer(recipient, value);
        } else if (payer == address(this)) {
            // pay with tokens already in the contract (for the exact input multihop case)
            TransferHelper.safeTransfer(token, recipient, value);
        } else {
            // pull payment
            TransferHelper.safeTransferFrom(token, payer, recipient, value);
        }
    }
}
