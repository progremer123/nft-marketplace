# NFT Marketplace 프로젝트 최종 보고서

**학번**: 92113633  
**이름**: 백이랑  
**과목**: 블록체인 스마트 컨트랙트  
**작성일**: 2025년 12월 18일

---

## 목차

1. [프로젝트 개요](#프로젝트-개요)
2. [요구사항 분석](#요구사항-분석)
3. [설계 및 구현](#설계-및-구현)
4. [스마트 컨트랙트](#스마트-컨트랙트)
5. [프론트엔드 구현](#프론트엔드-구현)
6. [배포 및 테스트](#배포-및-테스트)
7. [결론](#결론)

---

## 프로젝트 개요

본 프로젝트는 블록체인 기술을 활용한 **NFT Marketplace** 애플리케이션입니다. 
사용자는 토큰 드랍을 통해 ERC-20 토큰을 획득하고, 이를 이용해 NFT를 발행하고 거래할 수 있습니다.

### 핵심 목표

- ✅ ERC-20 토큰 발행 및 자동 드랍 기능 구현
- ✅ 누구나 NFT를 등록할 수 있는 민주적인 NFT 시스템 구현
- ✅ 토큰 기반 NFT 거래 마켓플레이스 구현
- ✅ 사용자 친화적인 웹 인터페이스 제공

---

## 요구사항 분석

### 1. ERC-20 토큰 드랍 기능

**요구사항**:
- 소유자가 발행한 토큰을 신청자에게 자동으로 일정 금액 전송
- 중복 신청 방지
- 일정량(1000 토큰) 자동 지급

**구현 내용**:
- `requestTokenDrop()` 함수: 신청자에게 1000 MTK 자동 전송
- `checkDropStatus()` 함수: 드랍 수령 여부 확인
- `hasReceivedDrop` 매핑: 중복 신청 방지

### 2. NFT 등록 기능

**요구사항**:
- 누구나 새로운 NFT를 등록할 수 있어야 함
- 기존 `onlyOwner` 제약 제거

**구현 내용**:
- `safeMint()` 함수에서 `onlyOwner` 제약 제거
- 누구나 NFT 민팅 가능하도록 수정
- IPFS를 통한 메타데이터 저장

### 3. NFT 마켓플레이스 기능

**요구사항**:
- 사용자가 보유한 NFT를 판매 등록 가능
- 다른 사용자의 NFT 구매 가능
- 토큰만을 거래 수단으로 사용

**구현 내용**:
- `listNFT()`: NFT를 마켓플레이스에 판매 등록
- `buyNFT()`: 판매 중인 NFT 구매
- `cancelListing()`: 판매 등록 취소
- 자동 수수료 계산 및 분배

### 4. 추가 기능

**구현된 추가 기능**:
- 토큰 전송: 사용자 간 토큰 직접 거래 가능
- 수수료 체계: 거래 시 1% 수수료 자동 징수
- 프로필 관리: 잔액 조회 및 거래 내역 관리
- 다크 모드 지원

---

## 설계 및 구현

### 아키텍처 다이어그램

```
┌─────────────────────────────────────────────────────────┐
│                     사용자 (Dapp)                        │
├─────────────────────────────────────────────────────────┤
│           Next.js 웹 인터페이스 (React/TypeScript)       │
│  ┌──────────────┬──────────────┬──────────────┐         │
│  │  마켓플레이  │  내 NFT      │  토큰 드랍  │         │
│  │  스 페이지   │  관리 페이지 │  페이지    │         │
│  └──────────────┴──────────────┴──────────────┘         │
├─────────────────────────────────────────────────────────┤
│  Wagmi + Viem (Web3 라이브러리)                          │
│  - 지갑 연결 관리                                        │
│  - 컨트랙트 상호작용                                    │
├─────────────────────────────────────────────────────────┤
│           Sepolia 테스트넷 (Ethereum)                    │
│  ┌─────────────┬─────────────┬──────────────┐          │
│  │  MyToken    │   MyNFT     │ Marketplace  │          │
│  │  (ERC-20)   │ (ERC-721)   │ (Custom)     │          │
│  └─────────────┴─────────────┴──────────────┘          │
└─────────────────────────────────────────────────────────┘
```

### 스마트 컨트랙트 상호작용 흐름

```
1. 토큰 드랍
   사용자 → requestTokenDrop() → MyToken → 사용자 (1000 MTK)

2. NFT 민팅
   사용자 → safeMint(to, uri) → MyNFT → 사용자 (NFT)

3. NFT 판매 등록
   사용자 → approve() → MyNFT에 Marketplace 승인
   사용자 → listNFT(tokenId, price) → Marketplace

4. NFT 구매
   구매자 → approve() → MyToken에 Marketplace 승인
   구매자 → buyNFT(tokenId) → Marketplace
   Marketplace → transferFrom() → MyToken (토큰 전송)
   Marketplace → safeTransferFrom() → MyNFT (NFT 전송)
```

---

## 스마트 컨트랙트

### 1. MyToken.sol (ERC-20)

**주요 기능**:

```solidity
// 토큰 드랍 요청
function requestTokenDrop() public {
    require(!hasReceivedDrop[msg.sender], "Already received");
    hasReceivedDrop[msg.sender] = true;
    _transfer(owner(), msg.sender, DROP_AMOUNT); // 1000 * 10^18
}

// 드랍 수령 여부 확인
function checkDropStatus(address account) public view returns (bool) {
    return hasReceivedDrop[account];
}

// 토큰 소각
function burn(uint256 amount) public {
    _burn(msg.sender, amount);
}
```

**주요 상태 변수**:
- `DROP_AMOUNT`: 1000 * 10^18 (드랍 금액)
- `hasReceivedDrop`: 드랍 수령 이력 추적

---

### 2. MyNFT.sol (ERC-721)

**주요 기능**:

```solidity
// NFT 민팅 (누구나 가능)
function safeMint(address to, string memory _tokenURI) public {
    uint256 tokenId = _tokenIdCounter.current();
    _tokenIdCounter.increment();
    _safeMint(to, tokenId);
    _setTokenURI(tokenId, _tokenURI);
}
```

**변경사항**:
- `onlyOwner` 제약 제거
- 누구나 NFT 발행 가능

---

### 3. MyNFTMarketplace.sol (Custom)

**주요 기능**:

```solidity
// NFT 판매 등록
function listNFT(uint256 _tokenId, uint256 _price) public {
    require(nftContract.ownerOf(_tokenId) == msg.sender);
    require(nftContract.isApprovedForAll(msg.sender, address(this)));
    listings[_tokenId] = Listing(_price, msg.sender, true);
}

// NFT 구매
function buyNFT(uint256 _tokenId) public {
    Listing storage listing = listings[_tokenId];
    uint256 feeAmount = (listing.price * feePercentage) / FEE_DENOMINATOR;
    uint256 netAmount = listing.price - feeAmount;
    
    tokenContract.transferFrom(msg.sender, listing.seller, netAmount);
    if (feeAmount > 0) {
        tokenContract.transferFrom(msg.sender, feeRecipient, feeAmount);
    }
    nftContract.safeTransferFrom(listing.seller, msg.sender, _tokenId);
    delete listings[_tokenId];
}

// 판매 등록 취소
function cancelListing(uint256 _tokenId) public {
    require(msg.sender == listings[_tokenId].seller);
    delete listings[_tokenId];
}
```

**수수료 체계**:
- 기본 수수료: 1% (100/10000)
- 소유자가 조정 가능

---

## 프론트엔드 구현

### 기술 스택

| 항목 | 기술 |
|------|------|
| 프레임워크 | Next.js 16.0.4 |
| UI 라이브러리 | React 19.2.0 |
| 언어 | TypeScript 5.0 |
| Web3 | Wagmi 3.0.1, Viem 2.40.3 |
| 스타일 | Tailwind CSS 4 |
| 상태 관리 | React Hooks |

### 주요 컴포넌트

#### 1. WalletConnect.tsx
- 지갑 연결/연결 해제
- 네트워크 전환 (Sepolia)
- 주소 표시

#### 2. Profile.tsx
**기능**:
- 잔액 조회 (ETH, 토큰, NFT)
- **토큰 드랍 신청** (새로운 기능)
- 토큰 전송
- 거래 내역 확인

**코드 예시**:
```typescript
const handleTokenDrop = async () => {
    setIsDropping(true);
    try {
        const receipt = await requestTokenDrop();
        setDropStatus(`드랍 완료! 1000 MTK를 받았습니다.`);
        await fetchTokenInfo();
    } catch (error) {
        setDropStatus(`드랍 실패: ${error.message}`);
    } finally {
        setIsDropping(false);
    }
};
```

#### 3. MintNFT.tsx
**기능**:
- NFT 이름, 설명, 이미지 입력
- IPFS에 메타데이터 업로드
- NFT 민팅 (누구나 가능)

#### 4. MyNFT.tsx
**기능**:
- 보유 NFT 목록 조회
- 판매 등록
- Marketplace 승인
- 판매 취소

#### 5. Marketplace.tsx
**기능**:
- 판매 중인 NFT 목록 조회
- NFT 상세 정보 확인
- 구매
- 토큰 승인

### UI 특징

- 반응형 디자인 (모바일/태블릿/데스크톱)
- 다크 모드 지원
- 직관적인 탭 네비게이션
- 실시간 상태 표시
- 에러 핸들링 및 사용자 알림

---

## 배포 및 테스트

### 배포 환경

- **네트워크**: Sepolia 테스트넷
- **체인 ID**: 11155111
- **RPC 엔드포인트**: https://rpc.sepolia.org

### 배포 절차

#### 1단계: Remix를 통한 배포

**MyToken 배포**:
1. Remix IDE (https://remix.ethereum.org/) 접속
2. MyToken.sol 작성
3. Solidity Compiler 0.8.20 설정
4. "Deploy & run transactions" → MetaMask 선택
5. 배포 주소 입력 → Deploy

**MyNFT 배포**:
1. MyNFT.sol 작성
2. 컴파일 및 배포

**MyNFTMarketplace 배포**:
1. MyNFTMarketplace.sol 작성
2. Constructor 파라미터:
   - MyToken 주소
   - MyNFT 주소
   - 수수료 수령자 (배포자)
   - 초기 수수료: 100 (1%)

#### 2단계: 프론트엔드 설정

```typescript
// src/lib/constants.ts
export const tokenContractAddress = '0x...';  // MyToken
export const nftContractAddress = '0x...';     // MyNFT
export const marketplaceContractAddress = '0x...'; // Marketplace
```

#### 3단계: 개발 서버 실행

```bash
npm install
npm run dev
```

### 테스트 시나리오

#### 테스트 1: 토큰 드랍

```
1. 신규 사용자로 로그인
2. 프로필 탭 → "드랍 신청" 버튼 클릭
3. 트랜잭션 확인
4. 결과: 사용자 지갑에 1000 MTK 추가 ✅
5. 동일 주소로 재신청 → 오류 메시지 확인 ✅
```

#### 테스트 2: NFT 민팅 및 판매

```
1. "NFT 민팅" 탭 이동
2. NFT 정보 입력 (이름, 설명, 이미지)
3. 민팅 버튼 클릭
4. 결과: MyNFT에 NFT 발행 완료 ✅
5. "내 NFT" 탭에서 발행된 NFT 확인 ✅
6. 가격 설정 후 판매 등록 ✅
```

#### 테스트 3: NFT 구매

```
1. 지갑 A (판매자): NFT 판매 등록
2. 지갑 B (구매자): 
   - 토큰 드랍 신청 (구매자 지갑에 토큰 추가)
   - 마켓플레이스에서 NFT 구매
3. 토큰 승인 → buyNFT() 실행
4. 결과:
   - 지갑 A: NFT 상실, 토큰 추가 ✅
   - 지갑 B: NFT 획득, 토큰 소비 ✅
```

### 배포된 컨트랙트 주소 (Sepolia)

> **주의**: 실제 배포 후 다음과 같은 형식으로 주소가 생성됩니다.

| 컨트랙트 | 주소 | 용도 |
|---------|------|------|
| MyToken | `0x...` | ERC-20 토큰 |
| MyNFT | `0x...` | ERC-721 NFT |
| Marketplace | `0x...` | NFT 거래 |

**배포 주소는 [DEPLOYMENT_ADDRESSES.md](./DEPLOYMENT_ADDRESSES.md)에 기록됩니다.**

---

## 추가 기능 및 개선사항

### 구현된 추가 기능

1. **토큰 전송 기능**
   - 사용자 간 토큰 직접 거래 가능
   - 모달 창을 통한 편리한 전송

2. **수수료 체계**
   - 자동 계산 및 분배
   - 소유자가 조정 가능

3. **다크 모드**
   - Tailwind CSS를 통한 자동 지원
   - 사용자 환경에 맞는 UI 제공

4. **IPFS 통합**
   - 메타데이터 및 이미지 저장
   - 분산형 스토리지

5. **배치 처리**
   - NFT 목록 조회 시 병렬 처리
   - 성능 최적화

### 향후 개선 사항

1. **커뮤니티 기능**
   - 댓글/평가 시스템
   - NFT 소유 인증 기반 포럼

2. **고급 검색**
   - 필터링 및 정렬 기능
   - 카테고리별 분류

3. **로열티 시스템**
   - NFT 원제작자에게 2차 판매 수익금 자동 배분

4. **경매 기능**
   - 시간 제한 경매
   - 입찰 시스템

5. **NFT 번들 거래**
   - 여러 NFT를 묶음으로 거래

---

## 결론

본 프로젝트는 블록체인 기술의 핵심 개념들을 실제로 구현한 완성도 높은 애플리케이션입니다.

### 주요 성과

✅ **ERC-20 토큰 드랍 기능**: 신청자에게 자동으로 토큰 지급  
✅ **민주적 NFT 시스템**: 누구나 NFT 발행 가능  
✅ **완전한 마켓플레이스**: 토큰 기반 P2P 거래  
✅ **사용자 친화적 인터페이스**: 직관적인 Web3 Dapp  
✅ **스케일링 최적화**: 배치 처리를 통한 성능 개선  

### 학습 성과

이 프로젝트를 통해 다음을 배웠습니다:

1. **스마트 컨트랙트 개발**
   - ERC-20, ERC-721 표준 이해
   - Solidity를 통한 계약 작성
   - 보안 고려사항

2. **Web3 통합**
   - Wagmi/Viem 라이브러리 활용
   - 지갑 연결 관리
   - 트랜잭션 처리

3. **풀스택 개발**
   - 프론트엔드 (Next.js, React)
   - 백엔드 (스마트 컨트랙트)
   - IPFS를 통한 분산 저장

4. **블록체인 개념**
   - 토큰 경제학
   - NFT 표준
   - 마켓플레이스 설계

---

## 참고 자료

- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Ethereum Smart Contract Best Practices](https://consensys.github.io/smart-contract-best-practices/)
- [Wagmi Documentation](https://wagmi.sh/)
- [Viem Documentation](https://viem.sh/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Solidity Documentation](https://docs.soliditylang.org/)

---

## 첨부 파일

1. [배포 가이드](./DEPLOYMENT_GUIDE.md)
2. [스마트 컨트랙트 소스 코드](./contract/)
3. [프론트엔드 소스 코드](./src/)
4. [배포된 컨트랙트 주소](./DEPLOYMENT_ADDRESSES.md)

---

**작성**: 백이랑  
**학번**: 92113633  
**날짜**: 2025년 12월 18일  
**과목**: 블록체인 스마트 컨트랙트
