import { abi as POOL_ABI } from './storyhunt-core/artifacts/contracts/StoryHuntPool.sol/StoryHuntPool.json'
import { Contract, Wallet } from 'ethers'
import { IStoryHuntPool } from '../../typechain'

export default function poolAtAddress(address: string, wallet: Wallet): IStoryHuntPool {
  return new Contract(address, POOL_ABI, wallet) as IStoryHuntPool
}
