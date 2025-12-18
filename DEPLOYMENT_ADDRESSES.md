# NFT Marketplace 배포 주소 (Sepolia 테스트넷)

**배포 날짜**: [배포 날짜 입력]  
**배포자**: 백이랑 (학번: 92113633)

---

## 스마트 컨트랙트 주소

### 1. MyToken (ERC-20)

- **컨트랙트 주소**: 
- **배포 트랜잭션**: 
- **Etherscan**: https://sepolia.etherscan.io/address/
- **특징**: 
  - 총 공급량: 1,000,000 MTK
  - 심볼: MTK
  - 소수점: 18자리
  - 드랍 금액: 1000 MTK

### 2. MyNFT (ERC-721)

- **컨트랙트 주소**: 
- **배포 트랜잭션**: 
- **Etherscan**: https://sepolia.etherscan.io/address/
- **특징**:
  - 이름: MyTestNFT
  - 심볼: MTN
  - URI 저장: ERC721URIStorage
  - 민팅: 누구나 가능

### 3. MyNFTMarketplace

- **컨트랙트 주소**: 
- **배포 트랜잭션**: 
- **Etherscan**: https://sepolia.etherscan.io/address/
- **특징**:
  - 기본 수수료: 1% (100/10000)
  - 수수료 수령자: 
  - 지원 토큰: MyToken

---

## 프론트엔드 설정

### constants.ts 업데이트

```typescript
export const tokenContractAddress = '0x...'; // MyToken 주소
export const nftContractAddress = '0x...';   // MyNFT 주소
export const marketplaceContractAddress = '0x...'; // MyNFTMarketplace 주소
```

---

## 배포 검증

### MyToken 검증

```bash
# Etherscan에서 확인할 항목:
- ✅ 초기 공급량: 1,000,000 MTK
- ✅ 배포자가 소유
- ✅ DROP_AMOUNT = 1000 * 10^18
- ✅ requestTokenDrop() 함수 존재
- ✅ checkDropStatus() 함수 존재
```

### MyNFT 검증

```bash
# Etherscan에서 확인할 항목:
- ✅ safeMint() 함수 (onlyOwner 제약 제거됨)
- ✅ ERC721URIStorage 활성화
- ✅ tokenURI() 지원
```

### MyNFTMarketplace 검증

```bash
# Etherscan에서 확인할 항목:
- ✅ listNFT() 함수
- ✅ buyNFT() 함수
- ✅ cancelListing() 함수
- ✅ getListing() 함수
- ✅ feePercentage = 100 (1%)
- ✅ 올바른 Token/NFT 주소 설정
```

---

## 테스트 주소

| 역할 | 주소 | ETH | MTK | NFT |
|------|------|-----|-----|-----|
| 배포자/소유자 | | | | |
| 테스트 사용자 1 | | | | |
| 테스트 사용자 2 | | | | |

---

## 거래 기록

### 테스트 거래 1: 토큰 드랍

| 항목 | 값 |
|------|-----|
| 사용자 | |
| 거래해시 | |
| 블록 | |
| 결과 | ✅ 성공 |

### 테스트 거래 2: NFT 민팅

| 항목 | 값 |
|------|-----|
| 사용자 | |
| 거래해시 | |
| 블록 | |
| Token ID | |
| 결과 | ✅ 성공 |

### 테스트 거래 3: NFT 판매 등록

| 항목 | 값 |
|------|-----|
| NFT ID | |
| 판매자 | |
| 가격 | |
| 거래해시 | |
| 결과 | ✅ 성공 |

### 테스트 거래 4: NFT 구매

| 항목 | 값 |
|------|-----|
| NFT ID | |
| 구매자 | |
| 가격 | |
| 거래해시 | |
| 결과 | ✅ 성공 |

---

## 성능 통계

- **가스 사용량**:
  - MyToken 배포: 약 `___` gas
  - MyNFT 배포: 약 `___` gas
  - Marketplace 배포: 약 `___` gas
  - 토큰 드랍: 약 `___` gas
  - NFT 민팅: 약 `___` gas
  - NFT 판매: 약 `___` gas
  - NFT 구매: 약 `___` gas

- **평균 거래 시간**: 약 10-30초 (Sepolia)

---

## 문제 해결 및 주의사항

### 문제 1: "Insufficient allowance" 오류

**원인**: Marketplace가 토큰을 전송할 권한이 없음  
**해결**: 
1. Profile 탭에서 "드랍 신청" 후 토큰 획득
2. Marketplace 구매 시 토큰 승인 수행

### 문제 2: "Marketplace not approved to transfer NFT" 오류

**원인**: Marketplace가 NFT를 전송할 권한이 없음  
**해결**: 
1. "내 NFT" 탭에서 NFT 선택
2. "Marketplace 승인" 버튼 클릭
3. 거래 확인

### 문제 3: "Already received a token drop" 오류

**원인**: 이미 드랍을 수령한 주소  
**해결**: 다른 지갑으로 테스트하거나, 새 주소 사용

---

## 환경 변수

```bash
# .env.local (프로젝트 루트)
NEXT_PUBLIC_SEPOLIA_RPC_URL=https://rpc.sepolia.org
```

---

## 자동 업데이트 스크립트

향후 배포 시, 다음 명령으로 자동 업데이트 가능:

```bash
# src/lib/constants.ts 자동 생성 (Hardhat 사용 시)
npm run update-contracts
```

---

**마지막 업데이트**: [날짜]  
**작성자**: 백이랑  
**확인**: [확인자 이름]
