import {
  abi as FACTORY_ABI,
  bytecode as FACTORY_BYTECODE,
} from '@uniswap/v3-core/artifacts/contracts/StoryHuntFactory.sol/StoryHuntFactory.json'
import { abi as FACTORY_V2_ABI, bytecode as FACTORY_V2_BYTECODE } from '@uniswap/v2-core/build/UniswapV2Factory.json'
import { Fixture } from 'ethereum-waffle'
import { ethers, waffle } from 'hardhat'
import { IStoryHuntFactory, IWIP9, MockTimeSwapRouter } from '../../typechain'

import WIP9 from '../contracts/WIP9.json'
import { Contract } from '@ethersproject/contracts'
import { constants } from 'ethers'

const wethFixture: Fixture<{ weth9: IWIP9 }> = async ([wallet]) => {
  const weth9 = (await waffle.deployContract(wallet, {
    bytecode: WIP9.bytecode,
    abi: WIP9.abi,
  })) as IWIP9

  return { weth9 }
}

export const v2FactoryFixture: Fixture<{ factory: Contract }> = async ([wallet]) => {
  const factory = await waffle.deployContract(
    wallet,
    {
      bytecode: FACTORY_V2_BYTECODE,
      abi: FACTORY_V2_ABI,
    },
    [constants.AddressZero]
  )

  return { factory }
}

const v3CoreFactoryFixture: Fixture<IStoryHuntFactory> = async ([wallet]) => {
  return (await waffle.deployContract(wallet, {
    bytecode: FACTORY_BYTECODE,
    abi: FACTORY_ABI,
  })) as IStoryHuntFactory
}

export const v3RouterFixture: Fixture<{
  weth9: IWIP9
  factory: IStoryHuntFactory
  router: MockTimeSwapRouter
}> = async ([wallet], provider) => {
  const { weth9 } = await wethFixture([wallet], provider)
  const factory = await v3CoreFactoryFixture([wallet], provider)

  const router = (await (await ethers.getContractFactory('MockTimeSwapRouter')).deploy(
    factory.address,
    weth9.address
  )) as MockTimeSwapRouter

  return { factory, weth9, router }
}
