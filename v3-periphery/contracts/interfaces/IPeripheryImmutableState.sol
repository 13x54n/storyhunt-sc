// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

/// @title Immutable state
/// @notice Functions that return immutable state of the router
interface WIPeripheryImmutableState {
    /// @return Returns the address of the StoryHunt V3 factory
    function factory() external view returns (address);

    /// @return Returns the address of WIP9
    function WIP9() external view returns (address);
}
