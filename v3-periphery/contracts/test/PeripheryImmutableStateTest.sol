// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;

import '../base/PeripheryImmutableState.sol';

contract PeripheryImmutableStateTest is PeripheryImmutableState {
    constructor(address _factory, address _WIP9) PeripheryImmutableState(_factory, _WIP9) {}
}
