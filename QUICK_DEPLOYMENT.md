# ⚡ 빠른 배포 가이드 (Quick Start)

## 5분 안에 배포하기

### 📋 준비물 체크리스트

- [ ] MetaMask 설치 완료
- [ ] Sepolia 네트워크 추가됨
- [ ] Sepolia 테스트 ETH 보유 (최소 0.15 ETH)
- [ ] 컨트랙트 파일 3개 준비 (MyToken.sol, MyNFT.sol, MyNFTMarketplace.sol)

---

## 🚀 단계별 배포 (클릭만으로!)

### Step 1: Remix 열기
👉 **https://remix.ethereum.org** 접속

### Step 2: 파일 업로드 (30초)
1. 왼쪽 `File Explorer` 클릭
2. `contracts` 폴더에 3개 파일 드래그 앤 드롭:
   - MyToken.sol
   - MyNFT.sol
   - MyNFTMarketplace.sol

### Step 3: 컴파일 (30초)
1. 왼쪽 `Solidity Compiler` 아이콘 클릭
2. Compiler 버전: **0.8.20** 선택
3. 각 파일 클릭 후 `Compile` 버튼 3번 클릭

✅ **녹색 체크마크** 확인!

### Step 4: 배포 환경 설정 (30초)
1. 왼쪽 `Deploy & Run Transactions` 클릭
2. **Environment**: `Injected Provider - MetaMask` 선택
3. MetaMask 팝업 → **연결** 클릭
4. 네트워크: **Sepolia** 확인

### Step 5: 배포 시작! (3분)

#### 5-1. MyToken 배포
```
CONTRACT: MyToken 선택
Constructor: [본인 MetaMask 주소 붙여넣기]
→ Deploy 클릭
→ MetaMask 승인
→ ⚠️ 주소 복사해서 메모장에 저장!
```

**예시:**
```
MyToken: 0xABC123... ← 여기 복사!
```

#### 5-2. MyNFT 배포
```
CONTRACT: MyNFT 선택
Constructor: (비어있음)
→ Deploy 클릭
→ MetaMask 승인
→ ⚠️ 주소 복사해서 메모장에 저장!
```

**예시:**
```
MyNFT: 0xDEF456... ← 여기 복사!
```

#### 5-3. MyNFTMarketplace 배포
```
CONTRACT: MyNFTMarketplace 선택
Constructor 입력:
  _tokenAddress: [Step 5-1에서 복사한 MyToken 주소]
  _nftAddress: [Step 5-2에서 복사한 MyNFT 주소]
  _feeRecipient: [본인 MetaMask 주소]
  initialFeePercentage: 100
→ Deploy 클릭
→ MetaMask 승인
→ ⚠️ 주소 복사해서 메모장에 저장!
```

**예시:**
```
MyNFTMarketplace: 0xGHI789... ← 여기 복사!
```

---

## 📝 메모장 예시

배포 후 메모장에 다음처럼 저장하세요:

```
=== 배포 완료 주소 ===
MyToken: 0xA20737cA6f0a59ba9A60cFD0F0662500833CA108
MyNFT: 0x6EE7d2F8698B078657c38B6ac917167A5E96Aa90
MyNFTMarketplace: 0xa4320A7C74D4Afe633C2fc019e26F695635FcE5C
배포 날짜: 2025-12-18
```

---

## 🔧 Frontend 업데이트 (1분)

배포가 끝나면 VS Code로 돌아와서:

### 자동 업데이트 명령어 실행:

```powershell
# constants.ts 파일 열기
code src/lib/constants.ts
```

그리고 아래 내용을 **복사해서 붙여넣기**:

```typescript
export const TOKEN_ADDRESS = '0x여기에_MyToken_주소';
export const NFT_ADDRESS = '0x여기에_MyNFT_주소';
export const MARKETPLACE_ADDRESS = '0x여기에_MyNFTMarketplace_주소';
export const CHAIN_ID = 11155111; // Sepolia
```

**주소 붙여넣기:**
- `0x여기에_MyToken_주소` → Step 5-1에서 복사한 주소
- `0x여기에_MyNFT_주소` → Step 5-2에서 복사한 주소
- `0x여기에_MyNFTMarketplace_주소` → Step 5-3에서 복사한 주소

**저장:** `Ctrl + S`

---

## ✅ 테스트 (2분)

### 1. 서버 재시작
```powershell
npm run dev
```

### 2. 브라우저 열기
👉 **http://localhost:3000**

### 3. 기능 테스트
- [ ] MetaMask 연결
- [ ] Profile → **토큰 드랍 신청** 클릭
- [ ] NFT 민팅 → 이미지 업로드 → **민팅** 클릭
- [ ] 내 NFT → NFT 클릭 → **마켓에 등록** 클릭

---

## 🎉 완료!

모든 기능이 작동하면 배포 성공입니다!

### 배포 확인 방법:

**Sepolia Etherscan에서 확인:**
```
https://sepolia.etherscan.io/address/[컨트랙트_주소]
```

예시:
```
https://sepolia.etherscan.io/address/0xA20737cA6f0a59ba9A60cFD0F0662500833CA108
```

---

## ❓ 자주 묻는 질문

### Q: MetaMask가 연결이 안 돼요
**A:** Remix 페이지 새로고침 후 다시 시도

### Q: Deploy 버튼이 안 눌려요
**A:** Constructor 파라미터를 정확히 입력했는지 확인

### Q: 트랜잭션이 실패해요
**A:** Sepolia ETH 잔액 확인 (최소 0.05 ETH 필요)

### Q: 토큰 드랍이 안 돼요
**A:** 새 컨트랙트 주소를 constants.ts에 업데이트했는지 확인

---

## 🆘 도움이 필요하면?

상세한 가이드: **DEPLOYMENT_GUIDE.md** 참조

**학번:** 92113633  
**이름:** 백이랑
