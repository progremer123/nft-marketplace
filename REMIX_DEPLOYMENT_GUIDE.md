# 🚀 Remix IDE 스마트 컨트랙트 배포 가이드

## 📋 목차

1. [준비사항](#준비사항)
2. [Remix IDE 배포](#remix-ide-배포)
3. [Frontend 연결](#frontend-연결)
4. [배포 검증](#배포-검증)
5. [문제 해결](#문제-해결)

---

## 준비사항

### 필수 도구

- ✅ **MetaMask** 지갑 설치
- ✅ **Sepolia 테스트 ETH** (최소 0.15 ETH)
- ✅ **컨트랙트 파일** (contract 폴더 내 3개 파일)

### Sepolia ETH 받기

1. **Alchemy Faucet**: https://sepoliafaucet.com
2. **Infura Faucet**: https://www.infura.io/faucet/sepolia
3. **Chainlink Faucet**: https://faucets.chain.link/sepolia

---

## Remix IDE 배포

### Step 1: Remix 접속

👉 https://remix.ethereum.org

### Step 2: 파일 준비

#### 방법 1: 직접 업로드
1. Remix 왼쪽 `File Explorer` 클릭
2. `contracts` 폴더 생성
3. 컨트랙트 파일 3개를 드래그 앤 드롭:
   - `MyToken.sol`
   - `MyNFT.sol`
   - `MyNFTMarketplace.sol`

#### 방법 2: GitHub에서 가져오기
```
File > Load from GitHub
URL: [프로젝트 GitHub URL]/contract/MyToken.sol
```

### Step 3: 컴파일

1. 왼쪽 패널 `Solidity Compiler` 아이콘 클릭
2. **Compiler 버전**: `0.8.20` 선택
3. **각 파일 컴파일**:
   - MyToken.sol 선택 → `Compile MyToken.sol` 클릭
   - MyNFT.sol 선택 → `Compile MyNFT.sol` 클릭
   - MyNFTMarketplace.sol 선택 → `Compile MyNFTMarketplace.sol` 클릭

**✅ 컴파일 성공:** 녹색 체크마크 표시 확인

**⚠️ 경고 무시 가능:**
- `SPDX license identifier not provided`
- `Warning: Visibility for constructor is ignored`

### Step 4: MetaMask 연결

1. 왼쪽 패널 `Deploy & Run Transactions` 클릭
2. **Environment**: `Injected Provider - MetaMask` 선택
3. MetaMask 팝업이 뜨면 **연결** 클릭
4. **Account**: 본인 계정 확인
5. **Network**: Sepolia (Chain ID: 11155111) 확인

### Step 5: MyToken 배포

```
┌─────────────────────────────────────┐
│ CONTRACT: MyToken 선택               │
│ Constructor Parameters:             │
│   initialOwner: [본인 MetaMask 주소]  │
└─────────────────────────────────────┘
```

**배포 절차:**
1. `CONTRACT` 드롭다운에서 **MyToken** 선택
2. Constructor 파라미터:
   - `initialOwner`: MetaMask 주소 복사/붙여넣기
     - 예: `0x1234567890abcdef1234567890abcdef12345678`
3. 🟠 `Deploy` 버튼 클릭
4. MetaMask 팝업 → **확인** 클릭
5. ⏳ 트랜잭션 대기 (약 15초)
6. ✅ 배포 완료 확인

**배포된 주소 저장:**
```
MyToken: 0x[복사한_주소]
```

📋 **메모장에 기록하세요!**

### Step 6: MyNFT 배포

```
┌─────────────────────────────────────┐
│ CONTRACT: MyNFT 선택                 │
│ Constructor Parameters: (없음)       │
└─────────────────────────────────────┘
```

**배포 절차:**
1. `CONTRACT` 드롭다운에서 **MyNFT** 선택
2. Constructor 파라미터 없음 (비어있음)
3. 🟠 `Deploy` 버튼 클릭
4. MetaMask 팝업 → **확인** 클릭
5. ⏳ 트랜잭션 대기
6. ✅ 배포 완료 확인

**배포된 주소 저장:**
```
MyNFT: 0x[복사한_주소]
```

### Step 7: MyNFTMarketplace 배포

```
┌─────────────────────────────────────┐
│ CONTRACT: MyNFTMarketplace 선택      │
│ Constructor Parameters:             │
│   _tokenAddress: [MyToken 주소]      │
│   _nftAddress: [MyNFT 주소]          │
│   _feeRecipient: [본인 주소]          │
│   initialFeePercentage: 100         │
└─────────────────────────────────────┘
```

**배포 절차:**
1. `CONTRACT` 드롭다운에서 **MyNFTMarketplace** 선택
2. Constructor 파라미터 입력:
   ```
   _tokenAddress: 0x[Step 5에서 배포한 MyToken 주소]
   _nftAddress: 0x[Step 6에서 배포한 MyNFT 주소]
   _feeRecipient: 0x[본인 MetaMask 주소]
   initialFeePercentage: 100
   ```
3. 🟠 `Deploy` 버튼 클릭
4. MetaMask 팝업 → **확인** 클릭
5. ⏳ 트랜잭션 대기
6. ✅ 배포 완료 확인

**배포된 주소 저장:**
```
MyNFTMarketplace: 0x[복사한_주소]
```

---

## 배포 완료! 🎉

### 최종 배포 주소 예시:

```plaintext
=== NFT Marketplace 배포 주소 ===
MyToken:          0xA20737cA6f0a59ba9A60cFD0F0662500833CA108
MyNFT:            0x6EE7d2F8698B078657c38B6ac917167A5E96Aa90
MyNFTMarketplace: 0xa4320A7C74D4Afe633C2fc019e26F695635FcE5C

네트워크: Sepolia (Chain ID: 11155111)
배포 날짜: 2025-12-18
배포자: 백이랑 (92113633)
```

---

## Frontend 연결

### 1. constants.ts 업데이트

VS Code에서 파일 열기:
```
src/lib/constants.ts
```

**내용 수정:**
```typescript
// 새로 배포한 컨트랙트 주소로 변경
export const TOKEN_ADDRESS = '0x[MyToken_주소]';
export const NFT_ADDRESS = '0x[MyNFT_주소]';
export const MARKETPLACE_ADDRESS = '0x[MyNFTMarketplace_주소]';
export const CHAIN_ID = 11155111; // Sepolia
```

**예시:**
```typescript
export const TOKEN_ADDRESS = '0xA20737cA6f0a59ba9A60cFD0F0662500833CA108';
export const NFT_ADDRESS = '0x6EE7d2F8698B078657c38B6ac917167A5E96Aa90';
export const MARKETPLACE_ADDRESS = '0xa4320A7C74D4Afe633C2fc019e26F695635FcE5C';
export const CHAIN_ID = 11155111;
```

### 2. 개발 서버 재시작

PowerShell에서:
```powershell
# 서버 중지 (Ctrl+C)
# 서버 재시작
npm run dev
```

### 3. 브라우저에서 테스트

👉 http://localhost:3000

---

## 배포 검증

### Remix에서 기능 테스트

#### MyToken 테스트

**Deployed Contracts**에서 MyToken 확장:

1. **DROP_AMOUNT** 클릭
   - 결과: `1000000000000000000000` (1000 토큰)
   
2. **balanceOf** 입력: `[본인 주소]`
   - 결과: `1000000000000000000000000` (초기 공급량)

3. **requestTokenDrop** 클릭
   - MetaMask 승인
   - 다른 주소로 전환 후 테스트
   - 결과: 1000 토큰 받음

4. **checkDropStatus** 입력: `[본인 주소]`
   - 결과: `true` (드랍 받음)

#### MyNFT 테스트

**Deployed Contracts**에서 MyNFT 확장:

1. **safeMint** 입력:
   ```
   to: [본인 주소]
   _tokenURI: ipfs://QmTest123
   ```
   - MetaMask 승인
   - 결과: NFT #0 민팅 성공

2. **ownerOf** 입력: `0`
   - 결과: `[본인 주소]`

3. **tokenURI** 입력: `0`
   - 결과: `ipfs://QmTest123`

#### MyNFTMarketplace 테스트

**NFT Approve 먼저:**
1. MyNFT에서 `approve` 호출:
   ```
   to: [MyNFTMarketplace 주소]
   tokenId: 0
   ```

**Listing 등록:**
2. MyNFTMarketplace에서 `listNFT` 호출:
   ```
   _tokenId: 0
   _price: 100000000000000000000
   ```
   - 결과: NFT #0이 100 토큰에 등록됨

3. **listings** 입력: `0`
   - 결과:
     ```
     price: 100000000000000000000
     seller: [본인 주소]
     isListed: true
     ```

### Etherscan에서 확인

각 컨트랙트를 Sepolia Etherscan에서 확인:

```
https://sepolia.etherscan.io/address/[컨트랙트_주소]
```

**확인 사항:**
- ✅ Contract Creation 트랜잭션
- ✅ 배포 블록 번호
- ✅ Constructor Arguments
- ✅ Contract Bytecode

---

## 문제 해결

### 컴파일 에러

#### `Source file requires different compiler version`
**해결:**
- Compiler 버전을 `0.8.20`으로 변경
- Advanced Configurations → EVM Version: `default`

#### `ParserError: Expected pragma, import directive or contract/interface/library definition`
**해결:**
- 파일이 올바르게 복사되었는지 확인
- UTF-8 인코딩 확인

### 배포 에러

#### `Insufficient funds for gas * price + value`
**해결:**
- Sepolia Faucet에서 테스트 ETH 받기
- 최소 0.05 ETH 필요

#### `Transaction timeout`
**해결:**
- Gas Price를 높임 (예: 20 Gwei → 50 Gwei)
- 네트워크 혼잡도 확인 후 재시도

#### `Nonce too high`
**해결:**
- MetaMask → 설정 → 고급 → 계정 재설정
- **주의:** 트랜잭션 기록 초기화됨

#### `Invalid address`
**해결:**
- 주소가 `0x`로 시작하는지 확인
- 주소 길이 42자 (0x + 40자) 확인
- 체크섬 주소 사용

### MetaMask 연결 문제

#### MetaMask가 팝업되지 않음
**해결:**
- 팝업 차단 해제
- MetaMask 확장 프로그램 활성화
- Brave 브라우저: Shield 설정 조정

#### Wrong network
**해결:**
- MetaMask에서 Sepolia 네트워크로 전환
- Network ID: 11155111 확인

#### Account not connected
**해결:**
- Remix 페이지 새로고침
- "Injected Provider" 다시 선택
- MetaMask에서 사이트 연결 허용

---

## 예상 Gas 비용

| 컨트랙트 | Gas Limit | Gas Price (20 Gwei) | 예상 비용 |
|---------|-----------|---------------------|----------|
| MyToken | 1,500,000 | 20 Gwei | ~0.03 ETH |
| MyNFT | 2,000,000 | 20 Gwei | ~0.04 ETH |
| Marketplace | 2,500,000 | 20 Gwei | ~0.05 ETH |
| **합계** | **6,000,000** | **20 Gwei** | **~0.12 ETH** |

**💡 Tip:** Sepolia는 무료이므로 가스비 걱정 없이 테스트 가능!

---

## 체크리스트

### 배포 전
- [ ] MetaMask 설치 완료
- [ ] Sepolia 네트워크 추가
- [ ] 테스트 ETH 충분 (0.15 ETH 이상)
- [ ] 컨트랙트 파일 3개 준비
- [ ] Remix IDE 접속 완료

### 배포 중
- [ ] MyToken 컴파일 성공
- [ ] MyNFT 컴파일 성공
- [ ] MyNFTMarketplace 컴파일 성공
- [ ] MetaMask 연결 완료
- [ ] 네트워크 Sepolia 확인

### 배포 후
- [ ] MyToken 주소 저장
- [ ] MyNFT 주소 저장
- [ ] MyNFTMarketplace 주소 저장
- [ ] constants.ts 업데이트 완료
- [ ] 개발 서버 재시작
- [ ] 브라우저에서 테스트 완료

---

## 다음 단계

배포가 완료되면:

1. ✅ Frontend 연결 확인
2. ✅ 토큰 드랍 기능 테스트
3. ✅ NFT 민팅 테스트
4. ✅ Marketplace 거래 테스트
5. ✅ 문서 업데이트 (DEPLOYMENT_ADDRESSES.md)

---

## 참고 자료

- **Remix 공식 문서**: https://remix-ide.readthedocs.io
- **OpenZeppelin**: https://docs.openzeppelin.com
- **Sepolia Testnet**: https://sepolia.etherscan.io
- **MetaMask 가이드**: https://metamask.io/faqs

---

**학번:** 92113633  
**이름:** 백이랑  
**날짜:** 2025-12-18
