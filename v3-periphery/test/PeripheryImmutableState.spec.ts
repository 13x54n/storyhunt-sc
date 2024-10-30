import { Contract } from 'ethers'
import { waffle, ethers } from 'hardhat'

import { Fixture } from 'ethereum-waffle'
import { PeripheryImmutableStateTest, IWIP9 } from '../typechain'
import { expect } from './shared/expect'
import { v3RouterFixture } from './shared/externalFixtures'

describe('PeripheryImmutableState', () => {
  const nonfungiblePositionManagerFixture: Fixture<{
    wip9: IWIP9
    factory: Contract
    state: PeripheryImmutableStateTest
  }> = async (wallets, provider) => {
    const { wip9, factory } = await v3RouterFixture(wallets, provider)

    const stateFactory = await ethers.getContractFactory('PeripheryImmutableStateTest')
    const state = (await stateFactory.deploy(factory.address, wip9.address)) as PeripheryImmutableStateTest

    return {
      wip9,
      factory,
      state,
    }
  }

  let factory: Contract
  let wip9: IWIP9
  let state: PeripheryImmutableStateTest

  let loadFixture: ReturnType<typeof waffle.createFixtureLoader>

  before('create fixture loader', async () => {
    loadFixture = waffle.createFixtureLoader(await (ethers as any).getSigners())
  })

  beforeEach('load fixture', async () => {
    ;({ state, wip9, factory } = await loadFixture(nonfungiblePositionManagerFixture))
  })

  it('bytecode size', async () => {
    expect(((await state.provider.getCode(state.address)).length - 2) / 2).to.matchSnapshot()
  })

  describe('#WIP9', () => {
    it('points to WIP9', async () => {
      expect(await state.WIP9()).to.eq(wip9.address)
    })
  })

  describe('#factory', () => {
    it('points to v3 core factory', async () => {
      expect(await state.factory()).to.eq(factory.address)
    })
  })
})
