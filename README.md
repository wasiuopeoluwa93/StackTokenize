

# StacksTokenize - Real World Asset Token Contract

A **Clarity Smart Contract** for tokenizing real-world assets (RWAs) into semi-fungible tokens (SFTs), enabling ownership, dividend distribution, governance through proposals and voting, and integration with oracles for price feeds. It also supports KYC-level compliance, on-chain metadata, and robust validation.

---

## 📌 Features

- ✅ Asset registration by contract owner
- ✅ Dividend claim based on token holdings
- ✅ Proposal creation and governance voting
- ✅ Price feed support via oracles
- ✅ KYC-level enforcement
- ✅ Robust input validations
- ✅ Modular design for extensibility

---

## 🏗 Contract Architecture

### 📄 Constants

- `contract-owner`: Initial owner of the contract (`tx-sender`)
- Error codes: Ranging from authorization, validation, to KYC errors
- Limits for asset values, durations, KYC level, and expiry

### 🧩 Data Maps

| Map | Purpose |
|-----|---------|
| `assets` | Stores asset metadata and state |
| `token-balances` | Stores SFT balances for each asset per owner |
| `kyc-status` | Stores KYC level, approval, and expiry per address |
| `proposals` | Stores governance proposals per asset |
| `votes` | Tracks who voted on which proposals |
| `dividend-claims` | Tracks last dividend claim to prevent double claims |
| `price-feeds` | Stores price info from oracles per asset |

---

## 🔐 Input Validations

Private helper functions enforce:
- Valid asset values
- Valid durations for proposals
- KYC level and expiry compliance
- Proper string formatting for metadata and titles
- Sufficient voting tokens and proposal duration limits

---

## 🔑 Core Functions

### ✅ `register-asset(metadata-uri, asset-value)`

**Description:** Registers a new real-world asset. Mints `tokens-per-asset` SFTs to `contract-owner`.

**Access:** Owner only

---

### 💰 `claim-dividends(asset-id)`

**Description:** Allows holders to claim dividends proportionally based on their token holdings.

**Access:** All token holders

---

### 🗳 `create-proposal(asset-id, title, duration, minimum-votes)`

**Description:** Allows eligible token holders to create governance proposals for asset-related decisions.

**Requirements:**
- Must hold ≥ 10% of tokens
- Proposal duration within set limits

---

### 🗳 `vote(proposal-id, vote-for, amount)`

**Description:** Vote on a proposal. Tokens are used to vote for or against.

**Constraints:**
- Only one vote per user per proposal
- Must vote before `end-height`

---

## 📖 Read-only Functions

| Function | Returns |
|---------|--------|
| `get-asset-info(asset-id)` | Full asset data |
| `get-balance(owner, asset-id)` | Token balance |
| `get-proposal(proposal-id)` | Proposal data |
| `get-vote(proposal-id, voter)` | Vote data |
| `get-price-feed(asset-id)` | Price feed data |
| `get-last-claim(asset-id, claimer)` | Last claimed dividends |

---

## 🔒 Private/Internal Utilities

| Function | Description |
|---------|-------------|
| `get-next-asset-id()` | Auto-increments asset ID |
| `get-next-proposal-id()` | Auto-increments proposal ID |
| `validate-*` | Validates input fields like metadata, title, value, etc. |

> **Note**: `get-last-asset-id` and `get-last-proposal-id` are placeholders and should be implemented for dynamic ID tracking (e.g., using a counter in a data var).

---

## 📊 Token Model

- Each asset registered mints `100,000` SFTs to the contract owner
- Dividends are distributed proportionally to token holders
- Voting power is determined by token holdings

---

## 🔍 KYC Enforcement (Planned)

- Validate KYC approval before allowing claims, transfers, or other sensitive operations
- KYC status stored in `kyc-status` map

---

## ⚠️ Error Codes

| Code | Description |
|------|-------------|
| `u100` | Only owner can call |
| `u101` | Asset/proposal not found |
| `u102` | Asset already listed |
| `u103` | Invalid amount or balance |
| `u104` | Not authorized |
| `u105` | KYC required |
| `u106` | Duplicate vote |
| `u107` | Voting period over |
| `u108` | Price data expired |
| `u110 - u117` | Various input validation errors |

---

## 🚀 Deployment & Usage Tips

1. **Owner registers assets** with unique metadata and value.
2. **Tokens are distributed** or sold to users (outside contract).
3. **Users create proposals** or **vote** based on holdings.
4. **Dividends** can be distributed (off-chain or via another contract).
5. **Oracle feeds** update `price-feeds` (manually or by another contract).

