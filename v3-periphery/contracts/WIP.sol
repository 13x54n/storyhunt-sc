// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;

import './libraries/openzeppelin/contracts/token/ERC20/ERC20.sol';

contract WrappedIP is ERC20 {
    constructor() ERC20("Wrapped IP", "WIP") {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }
}