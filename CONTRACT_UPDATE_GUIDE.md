# 컨트랙트 배포 가이드

## 현재 상태

현재 프로젝트는 **기존 배포된 컨트랙트**를 사용하고 있습니다:
- MyToken: `0xA20737cA6f0a59ba9A60cFD0F0662500833CA108`
- MyNFT: `0x6EE7d2F8698B078657c38B6ac917167A5E96Aa90`
- Marketplace: `0xa4320A7C74D4Afe633C2fc019e26F695635FcE5C`

## 문제점

코드에 추가한 새 기능들(토큰 드랍, 누구나 NFT 민팅)이 **기존 컨트랙트에는 없습니다**.

따라서 다음 기능들이 작동하지 않습니다:
- ❌ 토큰 드랍 (`requestTokenDrop`, `checkDropStatus`)
- ❌ 누구나 NFT 민팅 (기존은 `onlyOwner`)

## 해결 방법

### 옵션 1: 새 컨트랙트 배포 (권장)

새로운 기능이 포함된 컨트랙트를 Remix에서 배포하세요:

1. **MyToken.sol 배포**
   - [Remix IDE](https://remix.ethereum.org/)에서 `contract/MyToken.sol` 코드 복사
   - Sepolia 네트워크에 배포
   - 새 주소 기록

2. **MyNFT.sol 배포**
   - `contract/MyNFT.sol` 코드 복사
   - Sepolia 네트워크에 배포
   - 새 주소 기록

3. **MyNFTMarketplace.sol 배포**
   - `contract/MyNFTMarketplace.sol` 코드 복사
   - Constructor 파라미터:
     - `_tokenAddress`: 새로 배포한 MyToken 주소
     - `_nftAddress`: 새로 배포한 MyNFT 주소
     - `_feeRecipient`: 수수료 받을 주소
     - `initialFeePercentage`: 100 (1%)
   - 새 주소 기록

4. **`src/lib/constants.ts` 업데이트**

```typescript
export const tokenContractAddress = '0x새로운MyToken주소';
export const nftContractAddress = '0x새로운MyNFT주소';
export const marketplaceContractAddress = '0x새로운Marketplace주소';
```

5. **브라우저 새로고침**

### 옵션 2: 기존 컨트랙트 사용 (임시)

새 기능 없이 기존 컨트랙트로만 작동하게 하려면:

**토큰 드랍 UI 숨기기**
- 프로필 페이지에서 "드랍 신청" 버튼이 표시되지 않습니다
- 에러가 발생하지만 다른 기능은 정상 작동

**NFT 민팅 제한**
- 컨트랙트 소유자만 민팅 가능 (기존 동작)

## 현재 적용된 에러 처리

다음과 같이 에러 처리를 추가했습니다:

1. **Profile.tsx**
   - `checkDropStatus` 호출 실패 시 `false`로 간주
   - `requestTokenDrop` 에러 시 사용자 친화적 메시지 표시

2. **MyNFT.tsx**
   - 무한 로딩 방지 (타임아웃, finally 블록)
   - maxTokenId 축소 (100 → 20)
   - NFT 잔액 0이면 즉시 종료

## 권장 사항

✅ **새 컨트랙트 배포**를 권장합니다:
- 모든 새 기능 사용 가능
- 토큰 드랍으로 테스트 토큰 획득
- 누구나 NFT 민팅 가능
- 완전한 마켓플레이스 경험

배포 후 `DEPLOYMENT_ADDRESSES.md`에 새 주소를 기록하세요!
