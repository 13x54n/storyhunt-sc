// SPDX-License-Identifier: GPL-2.0-or-later
import '../core/contracts/interfaces/IStoryHuntPool.sol';

pragma solidity >=0.6.0;

import '../libraries/PoolTicksCounter.sol';

contract PoolTicksCounterTest {
    using PoolTicksCounter for IStoryHuntPool;

    function countInitializedTicksCrossed(
        IStoryHuntPool pool,
        int24 tickBefore,
        int24 tickAfter
    ) external view returns (uint32 initializedTicksCrossed) {
        return pool.countInitializedTicksCrossed(tickBefore, tickAfter);
    }
}
