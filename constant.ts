export enum CONTRACT_NAMES {
  // Token
  ERC20 = 'ERC20',
  IERC20 = 'IERC20',

  // MOCK
  MockWETH = 'MockWETH',
  MockERC20 = 'MockERC20',
  MockCErc20 = 'MockCErc20',
  MockCErc20_2 = 'MockCErc20_2',
  MockFeedRegistry = 'MockFeedRegistry',
  MockOracle = 'MockOracle',
  MockBank = 'MockBank',
  MockParaswap = 'MockParaswap',
  MockParaswapTransferProxy = 'MockParaswapTransferProxy',

  // Wrapper
  WERC20 = 'WERC20',
  WMasterChef = 'WMasterChef',
  WIchiFarm = 'WIchiFarm',
  WCurveGauge = 'WCurveGauge',
  WConvexBooster = 'WConvexBooster',
  WAuraBooster = 'WAuraBooster',
  WStakingRewards = 'WStakingRewards',
  PoolEscrow = 'PoolEscrow',
  PoolEscrowFactory = 'PoolEscrowFactory',

  // Oracles
  ChainlinkAdapterOracle = 'ChainlinkAdapterOracle',
  ChainlinkAdapterOracleL2 = 'ChainlinkAdapterOracleL2',
  CoreOracle = 'CoreOracle',
  UniswapV2Oracle = 'UniswapV2Oracle',
  WeightedBPTOracle = 'WeightedBPTOracle',
  StableBPTOracle = 'StableBPTOracle',
  CompStableBPTOracle = 'CompStableBPTOracle',
  ERC20KP3ROracle = 'ERC20KP3ROracle',
  CurveStableOracle = 'CurveStableOracle',
  CurveVolatileOracle = 'CurveVolatileOracle',
  CurveTricryptoOracle = 'CurveTricryptoOracle',
  UniswapV3AdapterOracle = 'UniswapV3AdapterOracle',
  AggregatorOracle = 'AggregatorOracle',
  IchiVaultOracle = 'IchiVaultOracle',

  // Protocol
  BlueberryBank = 'BlueberryBank',
  HardVault = 'HardVault',
  SoftVault = 'SoftVault',
  ProtocolConfig = 'ProtocolConfig',
  FeeManager = 'FeeManager',

  // Spell
  UniswapV2SpellV1 = 'UniswapV2SpellV1',
  SushiswapSpellV1 = 'SushiswapSpellV1',
  BalancerSpellV1 = 'BalancerSpellV1',
  ConvexSpell = 'ConvexSpell',
  CurveSpell = 'CurveSpell',
  IchiSpell = 'IchiSpell',
  AuraSpell = 'AuraSpell',
  ShortLongSpell = 'ShortLongSpell',

  // Interface
  IWETH = 'IWETH',
  IComptroller = 'IComptroller',
  ICEtherEx = 'ICEtherEx',
  ICErc20 = 'ICErc20',
  ICurvePool = 'ICurvePool',
  ICurveRegistry = 'ICurveRegistry',
  IERC20Metadata = 'IERC20Metadata',
  IUniswapV2Pair = 'IUniswapV2Pair',
  IUniswapV2Router02 = 'IUniswapV2Router02',
  IUniswapV3Pool = 'IUniswapV3Pool',
  IUniswapV3Router = 'IUniswapV3Router',
  IICHIVault = 'IICHIVault',
}

export const ADDRESS_GOERLI = {
  // Tokens
  MockUSDC: '0xcBB1082F4cD910E0A6C788Bc8F3eC07Dd1890670',
  MockIchiV1: '0x61a14CDC801C6eC337c7B1aC19270Fe7Ad792fC6',
  MockIchiV2: '0xe9B6CcC44dbA223ccF378aA630e63Bec52AaC392',
  ALCX: '0x9eD02f1C12AdB524EC901f37cB4d9b183B2e578d',
  BAL: '0x6c5ADE58aB4417012CBA549e5f8D7F71aE7Ede74',
  BLB: '0x745229756e606C88194be866B789A7a9d90BDEc5',
  CRV: '0xFA4cf6f231F198Ea682A0Dffd9B34679aF9Da754',
  DAI: '0xA2add465F592488267a589a6C21760a65de30aF0',
  LINK: '0xF22594caA98f2564139697C9B8424a68207a4C42',
  MIM: '0x90906A608F04be509F70B4a87801e496dF463166',
  OHM: '0x6d9E7fF19Abdc15017e1457c4e43d52E1Ada6325',
  WETH: '0x203788323Ab4B29220972972E7dEF2a037523A49',
  WBTC: '0x9Ca01f860BF0803625fF858EE63D3Fca68ECf43e',
  SUSHI: '0x90EAB39BbF837021f7454e310f6dB04e66B002d8',
  USDD: '0x1f194493aC9127e62E7f069A14aDCD51673Ea2D8',

  bALCX: '0x5DC9BC86A2BdC1261a941dd9520E11b06fF2F0b0',
  bBAL: '0xf7137e7AeFb7cC02353e6d4562144735EaDCFc9e',
  bBLB: '0x2D5335Be8753Ad83E93E9a76F7f00933C0152eF8',
  bCRV: '0x2cd7B693f8e42F50f3FEecfC2B4Fb464C6351ADe',
  bDAI: '0x05ccc8fb1D450256210e51f51D066c941485899E',
  bICHI: '0xeDE15d2aC91539900Ab1F90Aa5504A28C87Ed0cE',
  bLINK: '0xA1D7D979eC1b16b97b6a80ba2cf19D01180DCF42',
  bMIM: '0x681959b34C994211C803c6baa62D9b256487cd8e',
  bOHM: '0x5F2a934580409738b9eE4E1068012d225AB4013f',
  bSUSHI: '0xc16080Cb99f65fEe5A82e0A9aFDf6cA78E9DbF3D',
  bUSDC: '0xF0D4beb18031e8EC2E434D2ee8C977303f700918',
  bUSDD: '0x44AdbE2071a1fE267645AEF7df8e2FCdE0d595F8',
  bWBTC: '0xc849451401ca1dB63A39B08546619D84289D51F5',
  bWETH: '0x948E51bb758bbbf142CAe2f36FFDAe48a894a275',

  CHAINLINK_BTC: '0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB',
  CHAINLINK_ETH: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE',
  CHAINLINK_USD: '0x0000000000000000000000000000000000000348',

  // LP
  UNI_V3_USDC_ALCX: '0xED3f4BCB5Fef0413D1517F8fC6A7E1D12028965A',
  UNI_V3_USDC_BLB: '0x754485C767D52Dc9A1a4E7e847189749eE74fCe0',
  UNI_V3_ICHI_USDC: '0x410513DD3e841Af4b71Ea2E42ddEdA99cfd7AC3a',
  UNI_V3_USDC_WBTC: '0xfb6dABa71fC85E5a0595C17BE1a478D2198A0B48',
  UNI_V3_USDC_WETH: '0xE665EF4F113d7a4E853A5360BaDdda7e3637894a',

  // Compound
  COMP: '0x91EB071424A1C0cE760a51CBf733B7863fe9E57B',

  // ICHI
  ICHI_VAULT_USDC: '0xe768eb7adF7b555FA3726e17eb0595c9850cCBb9',
  ICHI_VAULT_USDC_BLB: '0xFa77E8Ecda5Cb0a0024eEe778AD7371592Dd8838',
  ICHI_VAULT_USDC_ALCX: '0xd63fa53d09c29AE49ab3EBD41ea00274c10bb119',
  ICHI_FARMING: '0x616b9E0598D92DF2c826DeeE5934c43269F9b62A',
};

export const ADDRESS = {
  // Tokens
  CRV: '0xD533a949740bb3306d119CC777fa900bA034cd52',
  CVXCRV: '0x62B9c7356A2Dc64a1969e19C23e4f579F9810Aa7',
  AURA: '0xc0c293ce456ff0ed870add98a0828dd4d2903dbf',
  AURABAL: '0x616e8BfA43F920657B3497DBf40D6b1A02D4608d',
  BAL: '0xba100000625a3754423978a60c9317c58a424e3D',
  CVX: '0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B',
  DAI: '0x6B175474E89094C44Da98b954EedeAC495271d0F',
  DPI: '0x1494ca1f11d487c2bbe4543e90080aeba4ba3c2b',
  ETH: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE',
  STETH: '0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84',
  FRAX: '0x853d955aCEf822Db058eb8505911ED77F175b99e',
  FRXETH: '0x5E8422345238F34275888049021821E8E08CAa1f',
  GHO: '0x40D16FC0246aD3160Ccc09B8D0D3A2cD28aE6C2f',
  ICHI: '0x111111517e4929D3dcbdfa7CCe55d30d4B6BC4d6',
  ICHI_FARM: '0x903bEF1736CDdf2A537176cf3C64579C3867A881',
  INDEX: '0x0954906da0Bf32d5479e25f46056d22f08464cab',
  LINK: '0x514910771AF9Ca656af840dff83E8264EcF986CA',
  MIM: '0x99D8a9C45b2ecA8864373A26D1459e3Dff1e17F3',
  OHM: '0x64aa3364F17a4D01c6f1751Fd97C2BD3D7e7f1D5',
  ALCX: '0xdBdb4d16EdA451D0503b854CF79D55697F90c8DF',
  PERP: '0xbC396689893D065F41bc2C6EcbeE5e0085233447',
  SNX: '0xc011a73ee8576fb46f5e1c5751ca3b9fe0af2a6f',
  SUSHI: '0x6B3595068778DD592e39A122f4f5a5cF09C90fE2',
  UNI: '0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984',
  USDT: '0xdAC17F958D2ee523a2206206994597C13D831ec7',
  SUSD: '0x57ab1ec28d129707052df4df418d58a2d46d5f51',
  USDC: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
  WBTC: '0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599',
  WETH: '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
  wstETH: '0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0',
  stETH: '0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84',
  ankrETH: '0xE95A203B1a91a908F9B9CE46459d101078c2c3cb',
  bUSDC: '0xdfd54ac444eEffc121E3937b4EAfc3C27d39Ae64',
  bICHI: '0xBDf1431c153A2A48Ee05C1F24b9Dc476C93F75aE',
  bDAI: '0xcB5C1909074C7ac1956DdaFfA1C2F1cbcc67b932',
  bCRV: '0x23ED643A4C4542E223e7c7815d420d6d42556006',
  bSUSHI: '0x8644e2126776daFE02C661939075740EC378Db00',
  bWBTC: '0x506c190340F786c65548C0eE17c5EcDbba7807e0',
  bWETH: '0x8E09cC1d00c9bd67f99590E1b2433bF4Db5309C3',
  bALCX: '', // TODO: update address after mainnet deploy
  bOHM: '', // TODO: update address after mainnet deploy
  bMIM: '', // TODO: update address after mainnet deploy
  bBAL: '', // TODO: update address after mainnet deploy
  bLINK: '', // TODO: update address after mainnet deploy
  crETH: '0xD06527D5e56A3495252A528C4987003b712860eE',
  crDAI: '0x92B767185fB3B04F881e3aC8e5B0662a027A1D9f',
  crUSDC: '0x44fbebd2f576670a6c33f6fc0b00aa8c5753b322',
  crUSDT: '0x797AAB1ce7c01eB727ab980762bA88e7133d2157',
  cUSDC: '0x39AA39c021dfbaE8faC545936693aC917d5E7563',
  cyUSDC: '0x76Eb2FE28b36B3ee97F3Adae0C69606eeDB2A37c',
  CHAINLINK_BTC: '0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB',
  CHAINLINK_ETH: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE',
  CHAINLINK_USD: '0x0000000000000000000000000000000000000348',
  USDC_ARB: '0xaf88d065e77c8cC2239327C5EDb3A432268e5831',
  CRV_ARB: '0x11cDb42B0EB46D95f990BeDD4695A6e3fA034978',
  UNI_ARB: '0xFa7F8980b0f1E64A2062791cc3b0871572f1F7f0',

  // LP
  UNI_V2_USDT_USDC: '0x3041cbd36888becc7bbcbc0045e3b1f144466f5f',
  UNI_V2_DPI_WETH: '0x4d5ef58aAc27d99935E5b6B4A6778ff292059991',
  UNI_V2_DAI_WETH: '0xa478c2975ab1ea89e8196811f51a7b7ade33eb11',
  UNI_V2_USDT_WETH: '0x0d4a11d5eeaac28ec3f61d100daf4d40471f1852',
  UNI_V2_USDC_CRV: '0x210a97ba874a8e279c95b350ae8ba143a143c159',
  UNI_V2_USDC_WETH: '0xb4e16d0168e52d35cacd2c6185b44281ec28c9dc',
  UNI_V2_WBTC_WETH: '0xbb2b8038a1640196fbe3e38816f3e67cba72d940',
  SUSHI_WETH_USDT: '0x06da0fd433c1a5d7a4faa01111c044910a184553',
  SUSHI_ICHIV1_WETH: '0x9cD028B1287803250B1e226F0180EB725428d069',
  BAL_WETH_DAI_8020: '0x8b6e6e7b5b3801fed2cafd4b22b8a16c2f2db21a',
  BAL_PERP_USDC_8020: '0xF54025aF2dc86809Be1153c1F20D77ADB7e8ecF4',
  UNI_V3_UNI_WETH: '0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801',
  UNI_V3_UNI_USDC: '0xD0fC8bA7E267f2bc56044A7715A489d851dC6D78',
  UNI_V3_ICHI_USDC: '0x8f0350c8Be74B4cB0458cbf04d16753000fDA9d0',
  UNI_V3_USDC_DAI: '0x5777d92f208679db4b9778590fa3cab3ac9e2168',
  UNI_V3_USDC_CRV: '0x9445bd19767f73dcae6f2de90e6cd31192f62589',
  UNI_V3_OHM_WETH: '0x88051b0eea095007d3bef21ab287be961f3d8598',
  UNI_V3_USDC_WSTETH: '0x4622Df6fB2d9Bee0DCDaCF545aCDB6a2b2f4f863',
  UNI_V3_USDC_WETH: '0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640',

  // Oracle
  Keep3rV1Oracle: '0x73353801921417F465377c8d898c6f4C0270282C',
  ChainlinkRegistry: '0x47Fb2585D2C56Fe188D0E6ec628a38b74fCeeeDf',
  ChainlinkSequencerArb: '0xFdB631F5EE196F0ed6FAa767959853A9F217697D',

  CHAINLINK_USDC_FEED: '0x50834F3163758fcC1Df9973b6e91f0F0F0434aD3',
  CHAINLINK_USDC_USD_FEED: '0x8fffffd4afb6115b954bd326cbe7b4ba576818f6',
  CHAINLINK_UNI_FEED: '0x9c917083fdb403ab5adbec26ee294f6ecada2720',
  CHAINLINK_UNI_USD_FEED: '0x553303d460ee0afb37edff9be42922d8ff63220e',
  CHAINLINK_CRV_FEED: '0xaebda2c976cfd1ee1977eac079b4382acb849325',
  CHAINLINK_CRV_USD_FEED: '0xcd627aa160a6fa45eb793d19ef54f5062f20f33f',
  CHAINLINK_ETH_USD_FEED: '0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419',
  CHAINLINK_STETH_USD_FEED: '0xcfe54b5cd566ab89272946f602d76ea879cab4a8',
  CHAINLINK_ALCX_ETH_FEED: '0x194a9AaF2e0b67c35915cD01101585A33Fe25CAa',
  CHAINLINK_BTC_USD_FEED: '0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c',
  CHAINLINK_DAI_USD_FEED: '0xaed0c38402a5d19df6e4c03f4e2dced6e29c1ee9',
  CHAINLINK_BAL_USD_FEED:'0xdf2917806e30300537aeb49a7663062f4d1f2b5f',
  CHAINLINK_FRAX_USD_FEED: '0xb9e1e3a9feff48998e45fa90847ed4d467e8bcfd',
  CHAINLINK_LINK_USD_FEED: '0x2c1d072e956affc0d435cb7ac38ef18d24d9127c',
  CHAINLINK_CRVUSD_USD_FEED: '0xeef0c605546958c1f899b6fb336c20671f9cd49f',
  // Dex Router
  UNI_V2_ROUTER: '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D',
  UNI_V3_ROUTER: '0xE592427A0AEce92De3Edee1F18E0157C05861564',
  SUSHI_ROUTER: '0xd9e1ce17f2641f24ae83637ab66a2cca9c378b9f',

  // Curve
  CRV_3Crv: '0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490',
  CRV_TriCrypto: '0xc4ad29ba4b3c580e6d59105fff484999997675ff',
  CRV_FRAXUSDC: '0x3175df0976dfa876431c2e9ee6bc45b65d3473cc',
  CRV_FRAX3Crv: '0xd632f22692FaC7611d2AA1C0D552930D43CAEd3B',
  CRV_FRXETH: '0xf43211935c781d5ca1a41d2041f397b8a7366c7a',
  CRV_STETH: '0x06325440D014e39736583c165C2963BA99fAf14E',
  CRV_MIM3CRV: '0x5a6A4D54456819380173272A5E8E9B9904BdF41B',
  CRV_CVXETH: '0x3A283D9c08E8b55966afb64C515f5143cf907611',
  CRV_CVXCRV_CRV: '0x971add32ea87f10bd192671630be3be8a11b8623',
  CRV_ALCX_FRAXBP: '0xf985005a3793dba4cce241b3c19ddcd3fe069ff4',
  CRV_OHM_FRAXBP: '0x5271045F7B73c17825A7A7aee6917eE46b0B7520',
  CRV_3Crv_POOL: '0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7',
  CRV_FRAXUSDC_POOL: '0xDcEF968d416a41Cdac0ED8702fAC8128A64241A2',
  CRV_GAUGE: '0x7D86446dDb609eD0F5f8684AcF30380a356b2B4c',
  CRV_REGISTRY: '0x90E00ACe148ca3b23Ac1bC8C240C2a7Dd9c2d7f5',
  CRV_ADDRESS_PROVIDER: '0x0000000022d53366457f9d5e68ec105046fc4383',
  CRV_GAUGE_CONTROLLER: '0x2F50D538606Fa9EDD2B11E2446BEb18C9D5846bB',

  // Curve Gauge
  CRV_GAUGE_3Crv: '0xbfcf63294ad7105dea65aa58f8ae5be2d9d0952a',
  CRV_GAUGE_3CrvId: 9,

  // Convex
  CVX_BOOSTER: '0xF403C135812408BFbE8713b5A23a04b3D48AAE31',
  CVX_3Crv_Id: 9,
  CVX_Frax3Crv_Id: 32,
  CVX_FraxEth_Id: 128,
  CVX_FraxUsdc_Id: 100,
  CVX_EthStEth_Id: 25,
  CVX_MIM_Id: 40,
  CVX_CvxCrv_Id: 157,

  // Aura
  AURA_BOOSTER: '0xA57b8d98dAE62B26Ec3bcC4a365338157060B234',
  AURA_OHM_ETH_POOL_ID: 55,
  AURA_WSTETH_WETH_POOL_ID: 153,
  AURA_UDU_POOL_ID: 76,
  AURA_UDU_ID: '0x79c58f70905f734641735bc61e45c19dd9ad60bc0000000000000000000004e7',
  AURA_WETH_AURA_ID: '0xcfca23ca9ca720b6e98e3eb9b6aa0ffc4a5c08b9000200000000000000000274',
  STASH_AURA: '0x8dDD55a18ad319Ffd25D09E057b25412eE511a09',

  // Balancer
  BAL_UDU: '0x79c58f70905f734641735bc61e45c19dd9ad60bc',
  BAL_AURA_STABLE: '0x3dd0843A028C86e0b760b1A76929d1C5Ef93a2dd',
  BAL_ETH_BASKET: '0x5aee1e99fe86960377de9f88689616916d5dcabe',
  BAL_WSTETH_STABLE: '0x32296969Ef14EB0c6d29669C550D4a0449130230',
  BAL_WSTETH_ANKRETH_STABLE: '0xdfE6e7e18f6Cc65FA13C8D8966013d4FdA74b6ba',
  BAL_WBTC_WETH: '0xa6f548df93de924d73be7d25dc02554c6bd66db5',
  BAL_BAL_WETH: '0x5c6Ee304399DBdB9C8Ef030aB642B10820DB8F56',
  BAL_OHM_WETH: '0xD1eC5e215E8148D76F4460e4097FD3d5ae0A3558',
  BAL_WSTETH_WETH: '0x93d199263632a4EF4Bb438F1feB99e57b4b5f0BD',
  BAL_WETH: '0x5c6ee304399dbdb9c8ef030ab642b10820db8f56',
  BAL_GHO_3POOL: '0xbE19d87Ea6cd5b05bBC34B564291c371dAe96747',
  BAL_WETH_3POOL: '0x08775ccb6674d6bDCeB0797C364C2653ED84F384',
  BALANCER_VAULT: '0xBA12222222228d8Ba445958a75a0704d566BF2C8',

  // Wrapper
  SUSHI_MASTERCHEF: '0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd',
  IC_DPI_STAKING_REWARDS: '0xB93b505Ed567982E2b6756177ddD23ab5745f309',
  PERP_BALANCER_LP_REWARDS: '0xb9840a4a8a671f79de3df3b812feeb38047ce552',

  // Lending Market
  CREAM_COMP: '0x3d5BC3c8d13dcB8bF317092d84783c2697AE9258',
  IRON_COMP: '0xab1c342c7bf5ec5f02adea1c2270670bca144cbb',
  BLB_COMPTROLLER: '0x37697298481d1B07B0AfFc9Ef5e9cDeec829EFc8',

  // ICHI
  ICHI_VAULT_USDC: '0x683F081DBC729dbD34AbaC708Fa0B390d49F1c39',
  ICHI_FARMING: '0x275dfe03bc036257cd0a713ee819dbd4529739c8',
  ICHI_VAULT_USDC_ALCX: '0x54E75feb06fC4a1136B6C94228a6eD6e03557C56',
  ICHI_VAULT_ALCX_USDC: '0x8684F7A55018b371455287ECAd4D10fe5851761C',
  ICHI_VAULT_ALCX_ETH: '0xa412b7983433E92299b50B8dF7B6D77D9732Bc63',
  ICHI_VAULT_ETH_USDC: '0xE151E7D9Dd2481D986d7146C249A70B66D0A4203',
  ICHI_VAULT_USDC_ETH: '0xc91d52239dD4C80C6F5E27A1B01bD2c582F56146',
  ICHI_VAULT_WBTC_USDC: '0x0e272EcD5d7D1baA59f25d09E3ab3E21F2E04c5a',
  ICHI_VAULT_USDC_WBTC: '0x037D8664e78d7548BFB98C6eeAD8559039F6eaEc',
  ICHI_VAULT_OHM_ETH: '0x5B266a067853BBBEf5Ba9687D5a7a605bbAD510E',
  ICHI_VAULT_LINK_ETH: '0x058D4B026E3BF037CA76B2B31FADbB282c366EA8',
  ICHI_VAULT_WBTC_ETH: '0x15b969e4CfC6106511e1F694215258d401dc5643',
  ICHI_VAULT_ETH_WBTC: '0xD1007271D6F8681d34D26EA88EE4B3BDc0D95513',

  // Paraswap
  AUGUSTUS_SWAPPER: '0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57',
  TOKEN_TRANSFER_PROXY: '0x216b4b4ba9f3e719726886d34a177484278bfcae',
};

export const ADDRESS_DEV = {
  bUSDC: '0x5554dFB8aEbC5A148286fFAF2F84E584b43fF213',
  bICHI: '0xb967Cf50ac4b77242fB160679cD2370782E52865',
  bDAI: '0xF4092505E4679754ECa5594369430D2660Ef0E65',
  bCRV: '0x128b2e83aEA186b2fD631DFc2027037D4966b0FB',
  bSUSHI: '0x7b3013877C78a4E7A49122EB7F77AD0778d1ce84',
  bWBTC: '0xa363Df117af827d1d9383288cA8a4f721C804D94',
  bWETH: '0xFF42449bdb73759D7872c39e808a29a8ED53BB2E',
  bWSTETH: '0xFF42449bdb73759D7872c39e808a29a8ED53BB2E',
  bLINK: '0xe891a4d7697037a34DF9E9fdb531cc209C37217D',
  bALCX: '0x8d0C61024c48608900CFB9F749AE8c09c1b25331',
  bOHM: '0x94C53DdAEEd3741393A9402272254321Aa6bdA4B',
  bMIM: '0x3710185363e89dCAA8537dC033f60A875F564EAe',
  bBAL: '0x2e231BAc57F74b3E184D6710123C177639c8904c',
  bCVXCRV: '0x6CCD80Ab1063640FE8f623dc174432353D8180C0',
  bFRAX: '0xa8EBdCba0536cA8D97489668Bb97DCC290689747',
  bUSDT: '0x208C2a01b72668C1F99f6bc4B57416fbb3827b4d',
};
