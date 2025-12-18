# NFT Marketplace 배포 가이드

## 프로젝트 개요

이 프로젝트는 ERC-20 토큰, ERC-721 NFT, 그리고 NFT 마켓플레이스 스마트 컨트랙트를 포함합니다.

### 주요 기능

1. **토큰 드랍 (Token Drop)**: 사용자가 신청하면 자동으로 1000 MTK 토큰을 받을 수 있는 기능
2. **NFT 발행**: 누구나 새로운 NFT를 등록할 수 있는 기능
3. **NFT 마켓플레이스**: 토큰을 사용하여 NFT를 거래할 수 있는 기능

---

## Sepolia 테스트넷 배포 방법

### 방법 1: Remix IDE 사용 (권장)

#### 1. MyToken 배포

1. [Remix IDE](https://remix.ethereum.org/)에 접속
2. 새 파일 생성: `MyToken.sol`
3. [contract/MyToken.sol](./contract/MyToken.sol)의 코드를 복사하여 붙여넣기
4. Solidity Compiler 버전을 `0.8.20` 이상으로 설정
5. 좌측 "Solidity Compiler" → "Compile MyToken.sol" 클릭
6. 좌측 "Deploy & run transactions" 클릭
7. Network를 "Injected Provider - MetaMask"로 변경 (Sepolia 네트워크에 미리 연결)
8. `MyToken` 컨트랙트 선택
9. Constructor 파라미터에 배포 주소 입력 (MetaMask에서 복사)
10. "Deploy" 버튼 클릭
11. **배포된 MyToken 컨트랙트 주소 기록**

#### 2. MyNFT 배포

1. 새 파일 생성: `MyNFT.sol`
2. [contract/MyNFT.sol](./contract/MyNFT.sol)의 코드 복사하여 붙여넣기
3. 컴파일 후 배포
4. **배포된 MyNFT 컨트랙트 주소 기록**

#### 3. MyNFTMarketplace 배포

1. 새 파일 생성: `MyNFTMarketplace.sol`
2. [contract/MyNFTMarketplace.sol](./contract/MyNFTMarketplace.sol)의 코드 복사
3. 컴파일
4. Constructor 파라미터 입력:
   - `_tokenAddress`: MyToken 주소
   - `_nftAddress`: MyNFT 주소
   - `_feeRecipient`: 수수료 받을 주소 (배포자 주소 사용 가능)
   - `initialFeePercentage`: 100 (1%)
5. 배포
6. **배포된 MyNFTMarketplace 컨트랙트 주소 기록**

---

### 방법 2: Hardhat 사용

```bash
# 프로젝트 폴더에서
npm install --save-dev hardhat @openzeppelin/contracts

# Hardhat 프로젝트 초기화
npx hardhat

# 배포 스크립트 실행
npx hardhat run scripts/deploy.js --network sepolia
```

---

## 환경 변수 설정

배포 후 `src/lib/constants.ts` 파일을 업데이트하여 계약 주소를 설정합니다:

```typescript
// src/lib/constants.ts

export const tokenContractAddress = '0x...'; // MyToken 주소
export const nftContractAddress = '0x...';     // MyNFT 주소
export const marketplaceContractAddress = '0x...'; // MyNFTMarketplace 주소
```

---

## 프론트엔드 설정

### 1. 의존성 설치

```bash
npm install
```

### 2. 개발 서버 실행

```bash
npm run dev
```

브라우저에서 `http://localhost:3000`에 접속합니다.

### 3. 지갑 연결

- MetaMask 또는 다른 Web3 지갑을 사용하여 연결
- Sepolia 테스트넷으로 네트워크 전환

---

## 사용 방법

### 1. 토큰 드랍 신청

1. "내 프로필" 탭 이동
2. "드랍 신청" 버튼 클릭
3. 확인 후 1000 MTK 토큰 획득

### 2. NFT 민팅

1. "NFT 민팅" 탭 이동
2. NFT 정보 입력:
   - 이름
   - 설명
   - 이미지 선택
3. "NFT 민팅" 버튼 클릭
4. 확인 후 NFT 발행

### 3. NFT 판매

1. "내 NFT" 탭에서 소유한 NFT 확인
2. 판매 가격 설정
3. "판매 등록" 클릭
4. Marketplace에 NFT 리스팅

### 4. NFT 구매

1. "마켓플레이스" 탭에서 판매 중인 NFT 확인
2. NFT 선택
3. 판매자로부터 구매 가능 금액 확인
4. "구매" 버튼 클릭
5. 거래 완료 시 NFT 획득

---

## 스마트 컨트랙트 주소 (Sepolia 테스트넷)

> **주의**: 아래 주소는 실제 배포 후 업데이트됩니다.

| 컨트랙트 | 주소 | Etherscan |
|---------|------|----------|
| MyToken | `0x...` | [링크](#) |
| MyNFT | `0x...` | [링크](#) |
| MyNFTMarketplace | `0x...` | [링크](#) |

---

## 추가 기능

### 토큰 전송
- "내 프로필" → "전송" 버튼으로 다른 주소에 토큰 전송 가능

### 수수료 조정
- Marketplace 컨트랙트 소유자는 `setFeePercentage()` 함수로 수수료 조정 가능

### 리스팅 취소
- "내 NFT" 또는 "마켓플레이스"에서 "판매 취소" 버튼으로 리스팅 취소 가능

---

## 문제 해결

### "Marketplace not approved to transfer NFT" 에러

NFT를 Marketplace에 승인해야 합니다:
1. "내 NFT" 탭에서 NFT 선택
2. "Marketplace 승인" 클릭
3. 거래 확인

### 토큰 부족

1. 드랍 신청으로 토큰 획득
2. "내 프로필"에서 토큰 수량 확인

### 네트워크 오류

- MetaMask에서 Sepolia 네트워크가 올바르게 설정되었는지 확인
- RPC URL이 올바르지 않으면 `src/lib/constants.ts`의 RPC URL 변경

---

## 테스트 시나리오

1. **토큰 드랍 테스트**
   - 신규 사용자로 로그인
   - "드랍 신청" 클릭
   - 토큰 획득 확인
   - 동일 주소로 재신청 → 오류 메시지 확인

2. **NFT 민팅 및 판매 테스트**
   - NFT 민팅
   - 마켓플레이스에 판매 등록
   - 다른 지갑에서 구매
   - 소유권 이전 확인

3. **마켓플레이스 거래 테스트**
   - 여러 NFT를 다양한 가격으로 등록
   - 지갑 간 거래 수행
   - 수수료 정산 확인

---

## 참고사항

- Sepolia 테스트넷 ETH는 [Sepolia Faucet](https://sepoliafaucet.com/)에서 획득 가능
- 모든 트랜잭션은 [Sepolia Etherscan](https://sepolia.etherscan.io/)에서 확인 가능
- 프로덕션 배포 전에 반드시 Mainnet에서 충분한 테스트 수행

---

## 라이선스

MIT
