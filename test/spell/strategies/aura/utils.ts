import { ethers, upgrades } from "hardhat";
import { utils } from "ethers";
import {
  WERC20,
  WAuraPools,
  AuraSpell,
  IAuraBooster,
} from "../../../../typechain-types";
import { ADDRESS, CONTRACT_NAMES } from "../../../../constant";
import { StrategyInfo, setupBasicBank } from "../utils";

export const strategies: StrategyInfo[] = [
  {
    type: "Pseudo-Neutral",
    address: ADDRESS.BAL_WSTETH_WETH,
    poolId: ADDRESS.AURA_WSTETH_WETH_POOL_ID,
    borrowAssets: [ADDRESS.wstETH /*, ADDRESS.WETH*/],
    collateralAssets: [ADDRESS.DAI],
    maxLtv: 500,
    maxStrategyBorrow: 5_000_000,
  },
];

export const setupStrategy = async () => {
  const protocol = await setupBasicBank();

  const escrow_Factory = await ethers.getContractFactory(CONTRACT_NAMES.PoolEscrow);
  const escrow = await escrow_Factory.deploy();

  const escrowFactory_Factory = await ethers.getContractFactory(CONTRACT_NAMES.PoolEscrowFactory);
  const escrowFactory = await escrowFactory_Factory.deploy(escrow.address);

  const WAuraPools = await ethers.getContractFactory(CONTRACT_NAMES.WAuraPools);
  const waura = <WAuraPools>(
    await upgrades.deployProxy(
      WAuraPools,
      [ADDRESS.AURA, ADDRESS.AURA_BOOSTER, escrowFactory.address],
      { unsafeAllow: ["delegatecall"] }
    )
  );
  
  const WERC20 = await ethers.getContractFactory(CONTRACT_NAMES.WERC20);
  const werc20 = <WERC20>(
    await upgrades.deployProxy(WERC20, { unsafeAllow: ["delegatecall"] })
  );

  const AuraSpell = await ethers.getContractFactory(CONTRACT_NAMES.AuraSpell);
  const auraSpell = <AuraSpell>(
    await upgrades.deployProxy(
      AuraSpell,
      [
        protocol.bank.address,
        werc20.address,
        ADDRESS.WETH,
        waura.address,
        ADDRESS.AUGUSTUS_SWAPPER,
        ADDRESS.TOKEN_TRANSFER_PROXY,
      ],
      { unsafeAllow: ["delegatecall"] }
    )
  );

  const auraBooster = <IAuraBooster>(
    await ethers.getContractAt("IAuraBooster", ADDRESS.AURA_BOOSTER)
  );

  escrowFactory.initialize(waura.address, ADDRESS.AURA_BOOSTER);

  // Setup Bank
  await protocol.bank.whitelistSpells([auraSpell.address], [true]);
  await protocol.bank.whitelistERC1155([werc20.address, waura.address], true);

  for (let i = 0; i < strategies.length; i += 1) {
    const strategy = strategies[i];

    await auraSpell.addStrategy(
      strategy.address,
      utils.parseUnits("100", 18),
      utils.parseUnits("2000000", 18)
    );

    await auraSpell.setCollateralsMaxLTVs(
      i,
      strategy.collateralAssets,
      strategy.collateralAssets.map(() => (strategy.maxLtv * 10000) / 100)
    );
  }

  return {
    protocol,
    auraSpell,
    waura,
    auraBooster,
  };
};