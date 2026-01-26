# Chimera Exchange Token (CEXT) - Technical Documentation

## Executive Summary

Chimera Exchange Token (CEXT) is a standard ERC20 token with ERC2612 Permit extension functionality. The token provides enhanced flexibility through meta-transaction approvals while maintaining complete compatibility with the ERC20 standard.

**Key Attributes:**
- **Token Name:** Chimera Exchange Token
- **Token Symbol:** CEXT
- **Decimals:** 18
- **Total Supply:** 1,000,000,000 CEXT (1 billion)
- **Solidity Version:** ^0.8.27
- **Standards:** ERC20, ERC2612 (Permit)

---

## 1. Contract Overview

### 1.1 Introduction

ChimeraExchangeToken is a non-upgradeable ERC20 token contract that inherits from OpenZeppelin's battle-tested implementations. It combines standard ERC20 functionality with the ERC2612 permit extension, enabling gas-efficient approval mechanisms.

### 1.2 Contract Structure

```solidity
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract ChimeraExchangeToken is ERC20, ERC20Permit {
    constructor(address recipient) 
        ERC20("Chimera Exchange Token", "CEXT") 
        ERC20Permit("Chimera Exchange Token") 
    {
        _mint(recipient, 1000000000 * 10 ** decimals());
    }
}
```

**Inheritance Chain:**
```
ChimeraExchangeToken
├── ERC20 (OpenZeppelin)
│   └── IERC20
└── ERC20Permit (OpenZeppelin)
    └── ERC2612
```

---

## 2. Technical Specifications

### 2.1 Token Parameters

| Parameter | Value | Notes |
|-----------|-------|-------|
| **Name** | Chimera Exchange Token | Human-readable token name |
| **Symbol** | CEXT | Trading symbol |
| **Decimals** | 18 | Standard for ERC20 tokens |
| **Total Supply** | 1,000,000,000 | One billion tokens |
| **Supply Distribution** | All to recipient | Single distribution at deployment |
| **Upgradeable** | No | Fixed implementation |
| **Pausable** | No | No pause mechanism |
| **Burnable** | No | No burn capability |

### 2.2 Numerical Representation

All token amounts are represented in the smallest unit (wei equivalent):
```
1 CEXT = 10^18 wei-equivalent units
```

**Examples:**
```
1 token    = 1 * 10^18 = 1,000,000,000,000,000,000
1,000 tokens = 1,000 * 10^18 = 1,000,000,000,000,000,000,000
1 billion = 1,000,000,000 * 10^18 = 1,000,000,000,000,000,000,000,000,000
```

---

## 3. Deployment

### 3.1 Constructor

**Function Signature:**
```solidity
constructor(address recipient)
```

**Parameters:**
- `recipient` (address): The address that receives the entire initial supply (1 billion CEXT)

**Requirements:**
- `recipient` must be a valid Ethereum address (can be EOA or contract)
- Typically should not be zero address (though technically allowed)

**Process:**
1. Initializes ERC20 with name "Chimera Exchange Token" and symbol "CEXT"
2. Initializes ERC2612 Permit functionality
3. Mints entire supply (1,000,000,000 tokens) to `recipient`
4. Sets recipient as the initial token holder

**Deployment Example:**

```javascript
// Using ethers.js
const recipient = "0x..."; // Owner/Treasury address
const factory = await ethers.getContractFactory("ChimeraExchangeToken");
const token = await factory.deploy(recipient);
await token.deployed();

console.log("Token deployed to:", token.address);
console.log("Initial holder:", recipient);
console.log("Balance:", await token.balanceOf(recipient));
```

### 3.2 Post-Deployment Verification

```javascript
// Verify token properties
const name = await token.name(); // "Chimera Exchange Token"
const symbol = await token.symbol(); // "CEXT"
const decimals = await token.decimals(); // 18
const supply = await token.totalSupply(); // 1000000000000000000000000000
const balance = await token.balanceOf(recipient); // equals supply
```

---

## 4. ERC20 Standard Functions

### 4.1 View Functions

#### balanceOf()
```solidity
function balanceOf(address account) public view returns (uint256)
```
Returns the token balance of an account.

**Example:**
```javascript
const balance = await token.balanceOf(userAddress);
console.log("User balance:", balance.toString());
```

#### totalSupply()
```solidity
function totalSupply() public view returns (uint256)
```
Returns the total token supply (fixed at 1 billion CEXT).

**Example:**
```javascript
const supply = await token.totalSupply();
console.log("Total supply:", supply.toString());
```

#### allowance()
```solidity
function allowance(address owner, address spender) public view returns (uint256)
```
Returns the amount of tokens `owner` has allowed `spender` to use.

**Example:**
```javascript
const approved = await token.allowance(owner, spenderAddress);
console.log("Approved amount:", approved.toString());
```

#### decimals()
```solidity
function decimals() public pure returns (uint8)
```
Returns the number of decimal places (18).

#### name()
```solidity
function name() public view returns (string memory)
```
Returns the token name: "Chimera Exchange Token"

#### symbol()
```solidity
function symbol() public view returns (string memory)
```
Returns the token symbol: "CEXT"

### 4.2 State-Changing Functions

#### transfer()
```solidity
function transfer(address to, uint256 amount) 
    public 
    returns (bool)
```

Transfers tokens from caller's balance to recipient.

**Parameters:**
- `to` (address): Recipient address (must not be zero)
- `amount` (uint256): Number of tokens to transfer

**Requirements:**
- Caller's balance must be >= amount
- Recipient address must not be zero

**Returns:** `true` on success (reverts on failure)

**Emits:**
```solidity
event Transfer(address indexed from, address indexed to, uint256 value)
```

**Example:**
```javascript
const tx = await token.transfer(recipientAddress, ethers.utils.parseEther("1000"));
await tx.wait();
```

**Gas Cost:** ~51,000 gas (typical)

#### approve()
```solidity
function approve(address spender, uint256 amount) 
    public 
    returns (bool)
```

Allows `spender` to use up to `amount` tokens on caller's behalf.

**Parameters:**
- `spender` (address): Address authorized to spend tokens
- `amount` (uint256): Maximum tokens spender can use

**Requirements:**
- Spender address must not be zero

**Returns:** `true` on success

**Emits:**
```solidity
event Approval(address indexed owner, address indexed spender, uint256 value)
```

**Security Note:** Setting approval to non-zero value when already approved can lead to race conditions. Best practice is to set to 0 first, then to desired amount.

**Example:**
```javascript
const tx = await token.approve(contractAddress, ethers.utils.parseEther("10000"));
await tx.wait();
```

**Gas Cost:** ~45,000 gas (typical)

#### transferFrom()
```solidity
function transferFrom(address from, address to, uint256 amount) 
    public 
    returns (bool)
```

Transfers tokens on behalf of another account (requires prior approval).

**Parameters:**
- `from` (address): Token owner address
- `to` (address): Recipient address
- `amount` (uint256): Number of tokens to transfer

**Requirements:**
- From address must have balance >= amount
- Caller must have approval >= amount
- To address must not be zero

**Returns:** `true` on success

**Emits:**
```solidity
event Transfer(address indexed from, address indexed to, uint256 value)
```

**Approval Updates:** Decreases caller's allowance by `amount`

**Example:**
```javascript
// Assumes prior approval
const tx = await token.transferFrom(ownerAddress, recipientAddress, ethers.utils.parseEther("500"));
await tx.wait();
```

**Gas Cost:** ~67,000 gas (typical)

---

## 5. ERC2612 Permit Extension

### 5.1 Overview

ERC2612 Permit enables token approvals to be conducted off-chain and executed as part of another transaction, eliminating the need for a separate approval transaction.

**Benefits:**
- Reduces transaction count (combine approve + transfer)
- Lower total gas consumption
- Better UX for dApps
- Enables meta-transactions

### 5.2 permit() Function

```solidity
function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
) public
```

Approves tokens using an off-chain signature instead of on-chain transaction.

**Parameters:**
- `owner` (address): Token owner
- `spender` (address): Authorized spender
- `value` (uint256): Approval amount
- `deadline` (uint256): Block timestamp after which permit expires
- `v, r, s` (uint8, bytes32, bytes32): EIP-191 signature components

**Requirements:**
- `deadline` must be >= current block timestamp
- Signature must be valid for the given parameters
- Owner must sign the permit data

**Emits:**
```solidity
event Approval(address indexed owner, address indexed spender, uint256 value)
```

### 5.3 Permit Usage Flow

**Step 1: Generate Signature Off-Chain**
```javascript
const owner = "0x...";
const spender = "0x...";
const value = ethers.utils.parseEther("1000");
const deadline = Math.floor(Date.now() / 1000) + 3600; // 1 hour

const domain = {
    name: "Chimera Exchange Token",
    version: "1",
    chainId: 1, // Ethereum mainnet
    verifyingContract: tokenAddress
};

const types = {
    Permit: [
        { name: "owner", type: "address" },
        { name: "spender", type: "address" },
        { name: "value", type: "uint256" },
        { name: "nonce", type: "uint256" },
        { name: "deadline", type: "uint256" }
    ]
};

const message = {
    owner: owner,
    spender: spender,
    value: value,
    nonce: await token.nonces(owner),
    deadline: deadline
};

const signature = await signer._signTypedData(domain, types, message);
const { v, r, s } = ethers.utils.splitSignature(signature);
```

**Step 2: Submit Permit On-Chain**
```javascript
const tx = await token.permit(owner, spender, value, deadline, v, r, s);
await tx.wait();
```

**Step 3: Use Approved Tokens**
```javascript
const transferTx = await token.transferFrom(owner, recipient, value);
await transferTx.wait();
```

### 5.4 nonces() Function

```solidity
function nonces(address owner) public view returns (uint256)
```

Returns the current nonce for an address (increments after each permit).

**Purpose:** Prevents replay attacks by ensuring each signature is unique.

**Example:**
```javascript
const nonce = await token.nonces(ownerAddress);
console.log("Current nonce:", nonce.toString());
```

### 5.5 DOMAIN_SEPARATOR()

```solidity
function DOMAIN_SEPARATOR() public view returns (bytes32)
```

Returns the EIP-712 domain separator for this contract.

**Usage:** Used internally and by off-chain signature generation.

---

## 6. Security Considerations

### 6.1 Design Features

| Feature | Benefit | Implementation |
|---------|---------|-----------------|
| **Non-upgradeable** | Immutable logic, no injection attacks | Fixed Solidity code |
| **Standard Library** | Audited and battle-tested | OpenZeppelin contracts |
| **Fixed Supply** | No inflation, predictable economics | Minted once at deployment |
| **Overflow Protection** | Automatic arithmetic protection | Solidity 0.8.27+ |

### 6.2 Known Limitations

**No Pause Function:**
- Token cannot be paused in emergency
- Cannot halt transfers if needed

**No Burn Function:**
- Tokens cannot be removed from circulation
- Supply is permanently fixed

**No Mint Function:**
- Additional tokens cannot be created
- One-time supply at deployment

**No Upgrade Mechanism:**
- Logic is fixed forever
- Bug fixes require new deployment

### 6.3 Common Risks & Mitigations

| Risk | Severity | Mitigation |
|------|----------|-----------|
| **Approval Race Condition** | Medium | Use safe approval patterns (approve to 0 first) |
| **Signature Replay** | Low | ERC2612 nonce mechanism prevents this |
| **Signature Expiration** | Low | Ensure deadline is reasonable (1-24 hours) |
| **Lost Private Keys** | High | Use multi-sig or hardware wallets for owner |

### 6.4 Operational Security

**Key Management:**
- Store recipient/owner private key securely
- Consider multi-signature wallet for production
- Never expose private keys in logs or configuration

**Monitoring:**
- Monitor Transfer events for unusual activity
- Track approval grant/revoke patterns
- Monitor for suspicious address interactions

---

## 7. Integration Guidelines

### 7.1 Basic Integration

**Adding Token to DeFi Protocol:**

```solidity
// In your contract
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract YourProtocol {
    IERC20 public cextToken;
    
    constructor(address _cextToken) {
        cextToken = IERC20(_cextToken);
    }
    
    function depositCEXT(uint256 amount) external {
        // User approves tokens first
        cextToken.transferFrom(msg.sender, address(this), amount);
        // ... rest of logic
    }
}
```

### 7.2 Using Permit for Meta-Transactions

```javascript
// Approve and transfer in single transaction
async function approveAndTransfer(owner, spender, recipient, amount) {
    const { v, r, s } = await generatePermitSignature(
        owner, 
        spender, 
        amount
    );
    
    const tx = await token.permit(owner, spender, amount, deadline, v, r, s);
    await tx.wait();
    
    const transferTx = await token.transferFrom(owner, recipient, amount);
    await transferTx.wait();
}
```

### 7.3 Safe Approval Pattern

```javascript
// Always do this for max safety
async function safeApprove(spender, amount) {
    // First set to 0
    await token.approve(spender, 0);
    // Then set to desired amount
    await token.approve(spender, amount);
}
```

---

## 8. Event Monitoring

### 8.1 ERC20 Events

#### Transfer Event
```solidity
event Transfer(address indexed from, address indexed to, uint256 value)
```

**Emitted when:** Tokens are transferred (includes minting and burning equivalents)

**Indexed parameters:** from, to (allows filtering by sender or recipient)

**Monitoring Example:**
```javascript
token.on("Transfer", (from, to, value, event) => {
    console.log(`${from} sent ${ethers.utils.formatEther(value)} tokens to ${to}`);
});
```

#### Approval Event
```solidity
event Approval(address indexed owner, address indexed spender, uint256 value)
```

**Emitted when:** Approval is granted or modified

**Indexed parameters:** owner, spender (allows filtering by approval grantor)

**Monitoring Example:**
```javascript
token.on("Approval", (owner, spender, value, event) => {
    console.log(`${owner} approved ${spender} to spend ${ethers.utils.formatEther(value)} tokens`);
});
```

---

## 9. Testing

### 9.1 Test Coverage

The contract includes comprehensive tests covering:

**Basic Functionality:**
- Token name and symbol verification
- Initial supply assignment
- Balance tracking

**Standard Operations:**
- Token transfers between accounts
- Token approvals and delegated transfers
- Balance updates

**Error Handling:**
- Transfer attempts exceeding balance
- Approval attempts with invalid addresses
- Edge cases and boundary conditions

### 9.2 Running Tests

```bash
# Run all tests
forge test

# Run with verbose output
forge test -v

# Run specific test file
forge test --match-path test/ChimeraExchangeToken.t.sol

# Run tests with gas reports
forge test --gas-report
```

### 9.3 Test Coverage Report

To generate coverage report:
```bash
forge coverage --report lcov
```

---

## 10. Integration Checklist

Before integrating CEXT into production:

```
[ ] Verify contract address on blockchain explorer
[ ] Confirm total supply (1 billion CEXT)
[ ] Test token transfers locally
[ ] Test permit signature generation and verification
[ ] Implement event monitoring
[ ] Set up emergency response procedures
[ ] Create user documentation
[ ] Deploy to testnet first
[ ] Final security review
[ ] Mainnet deployment
```

---

## 11. Glossary

| Term | Definition |
|------|-----------|
| **ERC20** | Ethereum standard for fungible tokens |
| **ERC2612** | Standard for permit/approve mechanism |
| **Permit** | Off-chain signature enabling meta-transactions |
| **Allowance** | Amount of tokens owner allows spender to use |
| **Nonce** | Sequential number preventing signature replay |
| **Domain Separator** | EIP-712 hash for signature verification |
| **Wei** | Smallest unit of Ethereum (token uses 18 decimals) |

---

## 12. External References

- [EIP-20: ERC20 Token Standard](https://eips.ethereum.org/EIPS/eip-20)
- [EIP-2612: Permit Extension](https://eips.ethereum.org/EIPS/eip-2612)
- [OpenZeppelin ERC20 Documentation](https://docs.openzeppelin.com/contracts/5.x/erc20)
- [OpenZeppelin Permit Documentation](https://docs.openzeppelin.com/contracts/5.x/erc20-extensions#ERC20Permit)

---

## 13. Support & Troubleshooting

### Common Issues

**Issue:** "Insufficient allowance" error
- **Cause:** Caller's approved amount is less than transfer amount
- **Solution:** Call `approve()` with higher amount first

**Issue:** "Permit signature invalid"
- **Cause:** Signature generated incorrectly or domain mismatch
- **Solution:** Verify domain (name, version, chainId, address)

**Issue:** "Permit deadline expired"
- **Cause:** Block timestamp exceeds permit deadline
- **Solution:** Use shorter deadline timeframe or regenerate permit

---

**Document Version:** 1.0  
**Last Updated:** January 26, 2026  
**Status:** Final  
**Contract Status:** Ready for Deployment
