# 🚀 CrowdFunding Smart Contract

Welcome to the **CrowdFunding** smart contract! This contract allows users to participate in a fundraising campaign, track contributions, request refunds if the goal isn't met, and enables the owner to withdraw funds when successful. 🎯💰

---

## 📜 Contract Overview
This contract is built using **Solidity (0.8.2)** and deployed using **Foundry**. The key features include:
- ✅ **Participate** in a crowdfunding campaign.
- 💸 **Withdraw funds** if the campaign is successful.
- 🔄 **Refund** contributors if the goal isn’t met.
- 🔍 **Track contributions** and participants.
- 🚀 **Automatic fund acceptance** via `receive()` and `fallback()` functions.

---

## 🔧 How It Works
1️⃣ **Deployment** 🏗️
   - When deployed, the contract records the deployer as the **OWNER**.
   - The campaign starts immediately and runs for **24 hours (86,400 seconds)**.

2️⃣ **Participation** 🏦
   - Users send ETH to participate via the `participate()` function.
   - Contributions are recorded, and an event is emitted. 📢

3️⃣ **Fund Withdrawal (Owner Only)** 💰
   - If the campaign meets the **goal of 10 ETH**, the owner can **withdraw** funds.

4️⃣ **Refunds** 🔄
   - If the goal isn’t met after **24 hours**, participants can request refunds.
   - The owner can also refund all participants via `RefundAll()`.

---

## 🔒 Security & Error Handling
The contract includes robust **error handling** to prevent misuse:
- ⛔ **Only the owner** can withdraw or refund all users.
- ⏳ **Contributions only allowed during the campaign period**.
- ❌ **Cannot participate twice** from the same address.
- 🚨 **Ensures refunds and withdrawals do not fail**.

---

## 🛠️ Functions Breakdown
| Function Name          | Description |
|------------------------|-------------|
| `participate()`        | Contribute to the crowdfunding campaign. |
| `refund()`            | Request a refund if the goal isn't met. |
| `withdraw()`          | Owner withdraws funds if the goal is met. |
| `RefundAll()`         | Owner refunds all participants if the goal fails. |
| `GetOwner()`          | Returns the contract owner's address. |
| `GetFunder(index)`    | Retrieves a funder's address by index. |
| `getAmountAUserFounded(funder)` | Returns the amount funded by a user. |
| `getDecimal()`        | Returns the decimal conversion factor. |
| `getInitialTime()`    | Retrieves the campaign start time. |
| `getDeadLine()`       | Returns the campaign deadline duration. |
| `getRaisedAmount()`   | Fetches the total funds raised. |

---

## 📝 Deployment & Testing
This contract is designed for **Foundry** 🛠️, a powerful testing framework for Ethereum smart contracts.

### 📌 Steps to Deploy & Test
1. Install **Foundry**: [Foundry Installation Guide](https://book.getfoundry.sh/)
2. Clone the repo:  
   ```sh
   git clone https://github.com/Elmirataghinasab/CrowdFunding.git
   cd CrowdFunding
   ```
3. Compile the contract:  
   ```sh
   forge build
   ```
4. Run tests:  
   ```sh
   forge test
   ```
5. Deploy the contract:  
   ```sh
   forge create --private-key <your-private-key> src/CrowdFunding.sol:CrowdFunding
   ```

---

## 📢 Events
The contract emits two key events:
- 📢 **`Participated(address user, uint256 amount)`** – Triggered when a user funds the campaign.
- 🔄 **`Refunded(address user, uint256 amount)`** – Triggered when a refund is processed.

---

## 📜 License
**MIT License** 📝 – Feel free to use, modify, and distribute!

---

## ✨ Contributors
👨‍💻 Built by **[Elmira]** with ❤️ and Solidity.

📧 **Contact**: [taghinasab8395@gmail.com]   

---

🚀 Happy Building! Let's fund the future together! 🌟