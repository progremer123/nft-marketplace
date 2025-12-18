// Sepolia 새 배포 주소 (Token Drop 기능 포함)
export const tokenContractAddress = '0x0A8dfBfBA5f5a8391c86B6596cf93E508695b381';
export const SEPOLIA_CHAIN_ID = 11155111;

// Sepolia RPC 엔드포인트 (fallback 포함)
// 환경 변수로 커스텀 RPC URL을 설정할 수 있습니다
// NEXT_PUBLIC_SEPOLIA_RPC_URL이 설정되어 있으면 우선 사용하고, 없으면 fallback 사용
const customRpcUrl = process.env.NEXT_PUBLIC_SEPOLIA_RPC_URL;

export const SEPOLIA_RPC_URL = customRpcUrl || 'https://rpc.sepolia.org';

// 환경 변수가 설정되어 있으면 그것을 우선 사용하고, 추가 fallback 제공 (401 에러 해결)
export const SEPOLIA_RPC_URLS = customRpcUrl
  ? [
      customRpcUrl, // 사용자가 설정한 RPC URL (우선 사용)
      'https://rpc.sepolia.org', // fallback 1
      'https://ethereum-sepolia-rpc.publicnode.com', // fallback 2
    ]
  : [
      'https://rpc.sepolia.org', // 기본값 (공개, 안정적)
      'https://ethereum-sepolia-rpc.publicnode.com', // fallback 1
      'https://sepolia-rpc.publicnode.com', // fallback 2
    ];

export const nftContractAddress = '0x5A5c6cA723bc5DCE687870BaF2709333DE2AD232';

export const marketplaceContractAddress =
  '0x0855943AaB9b7BC5832A9bb7d8a1D86971Cb69d6';

export const SEPOLIA_NETWORK = {
  chainId: `0x${SEPOLIA_CHAIN_ID.toString(16)}`,
  chainName: 'Sepolia',
  nativeCurrency: {
    name: 'Ether',
    symbol: 'ETH',
    decimals: 18,
  },
  rpcUrls: ['https://sepolia.infura.io/v3/'],
  blockExplorerUrls: ['https://sepolia.etherscan.io/'],
};
