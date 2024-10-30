// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

import './pool/IStoryHuntPoolImmutables.sol';
import './pool/IStoryHuntPoolState.sol';
import './pool/IStoryHuntPoolDerivedState.sol';
import './pool/IStoryHuntPoolActions.sol';
import './pool/IStoryHuntPoolOwnerActions.sol';
import './pool/IStoryHuntPoolEvents.sol';

/// @title The interface for a StoryHunt V3 Pool
/// @notice A StoryHunt pool facilitates swapping and automated market making between any two assets that strictly conform
/// to the ERC20 specification
/// @dev The pool interface is broken up into many smaller pieces
interface IStoryHuntPool is
    IStoryHuntPoolImmutables,
    IStoryHuntPoolState,
    IStoryHuntPoolDerivedState,
    IStoryHuntPoolActions,
    IStoryHuntPoolOwnerActions,
    IStoryHuntPoolEvents
{

}
