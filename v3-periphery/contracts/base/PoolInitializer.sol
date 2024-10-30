// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;

import '@uniswap/v3-core/contracts/interfaces/IStoryHuntFactory.sol';
import '@uniswap/v3-core/contracts/interfaces/IStoryHuntPool.sol';

import './PeripheryImmutableState.sol';
import '../interfaces/WIPoolInitializer.sol';

/// @title Creates and initializes V3 Pools
abstract contract PoolInitializer is WIPoolInitializer, PeripheryImmutableState {
    /// @inheritdoc WIPoolInitializer
    function createAndInitializePoolIfNecessary(
        address token0,
        address token1,
        uint24 fee,
        uint160 sqrtPriceX96
    ) external payable override returns (address pool) {
        require(token0 < token1);
        pool = IStoryHuntFactory(factory).getPool(token0, token1, fee);

        if (pool == address(0)) {
            pool = IStoryHuntFactory(factory).createPool(token0, token1, fee);
            IStoryHuntPool(pool).initialize(sqrtPriceX96);
        } else {
            (uint160 sqrtPriceX96Existing, , , , , , ) = IStoryHuntPool(pool).slot0();
            if (sqrtPriceX96Existing == 0) {
                IStoryHuntPool(pool).initialize(sqrtPriceX96);
            }
        }
    }
}
