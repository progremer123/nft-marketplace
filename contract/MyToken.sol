// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// OpenZeppelin 라이브러리에서 ERC20과 Ownable 계약을 가져옵니다.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 

/**
 * @title MyToken
 * @dev Sepolia 테스트를 위한 기본적인 ERC-20 토큰 구현입니다.
 * 토큰 드랍(Token Drop) 기능을 포함합니다.
 */
contract MyToken is ERC20, Ownable {
    // 토큰은 18자리 소수점(decimals)을 사용합니다.
    // 초기 공급량: 1,000,000 * 10^18
    uint256 private constant INITIAL_SUPPLY = 1_000_000 * 10**18;
    
    // 드랍 금액: 1000 * 10^18 (1000 토큰)
    uint256 public constant DROP_AMOUNT = 1000 * 10**18;
    
    // 이미 드랍을 받은 주소를 추적
    mapping(address => bool) public hasReceivedDrop;
    
    // 드랍 요청 이벤트
    event TokenDropped(address indexed recipient, uint256 amount);
    event DropRequested(address indexed requester);

    // 생성자: 토큰 이름과 심볼을 설정하고, 배포자에게 초기 공급량을 발행합니다.
    // 배포자는 자동으로 토큰의 소유자(Owner)가 됩니다.
    constructor(address initialOwner)
        ERC20("MyToken", "MTK")
        Ownable(initialOwner)
    {
        // 배포자(initialOwner)에게 초기 토큰을 발행(Mint)합니다.
        _mint(initialOwner, INITIAL_SUPPLY);
    }

    /**
     * @notice 토큰 드랍을 신청합니다. 한 주소당 한 번만 받을 수 있습니다.
     * @dev 신청자에게 일정량의 토큰(DROP_AMOUNT)을 자동으로 전송합니다.
     */
    function requestTokenDrop() public {
        require(!hasReceivedDrop[msg.sender], "Address has already received a token drop");
        require(balanceOf(owner()) >= DROP_AMOUNT, "Insufficient tokens to distribute");
        
        // 중복 수령 방지
        hasReceivedDrop[msg.sender] = true;
        
        // 오너에게서 신청자로 토큰 전송
        _transfer(owner(), msg.sender, DROP_AMOUNT);
        
        emit TokenDropped(msg.sender, DROP_AMOUNT);
        emit DropRequested(msg.sender);
    }
    
    /**
     * @notice 특정 주소가 이미 드랍을 받았는지 확인합니다.
     */
    function checkDropStatus(address account) public view returns (bool) {
        return hasReceivedDrop[account];
    }

    // 추가 기능: 소각(Burn) 기능 (선택 사항)
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}