 # Multi Signature Wallet Smart Contract
 
 <p align="center">
  <img width="135" height="135" alt="image" src="https://github.com/user-attachments/assets/ee026dfc-4860-4ddd-a893-764bb4bcd35a" />
</p>



## Project Overview
The `MultiSignature` contract is a secure Ethereum smart contract wallet designed to manage and protect digital assets through a multi-owner approval system. Instead of relying on a single private key or account to authorize transactions, the wallet requires multiple independent confirmations from predefined owners before funds or contract interactions can be executed. </br>

The contract allows authorized owners to:
* submit transaction proposals,
* confirm pending transactions,
* revoke confirmations before execution,
* and execute transactions once the required approval threshold is reached.

The wallet also supports: </br>
* Ether deposits,
* arbitrary smart contract calls through encoded calldata,
* transparent event logging,
* and transaction state tracking using an enum-based lifecycle system.

Key security mechanisms implemented include: </br>
* owner-based access control,
* duplicate confirmation prevention,
* transaction existence validation,
* quorum-based execution,
* custom error handling,
* and the Checks-Effects-Interactions pattern to reduce reentrancy risks.

This project `MultiSignature` demonstrates several advanced Solidity and smart contract engineering concepts such as:
* multisignature governance,
* low-level contract calls,
* mappings and nested mappings,
* state machines,
* custom errors,
* event-driven architecture,
* and secure treasury management.


## 📌 Features
* ****Multi-Owner Wallet Support:**** Supports multiple wallet owners. Tracks authorized signers and prevents unauthorized access.
* ****Custom Confirmation Threshold:**** During deployment, the contract allows setting the minimum number of confirmations required before executing a transaction.
* ****Owner Validation on Deployment:**** Prevents deployment with invalid owner addresses such as the zero address.
* ****Mandatory Owner Requirement:**** The contract cannot be deployed without at least two or more owner.
* ****Ether Deposit Support:**** Contract can receive ETH directly. Emits deposit events and Tracks updated balance.
* ****Duplicate Owner Prevention:**** Ensures the same owner address cannot be added more than once.
* ****Owner Access Control Modifier:**** Sensitive functions are protected with the `onlyOwner` modifier.
* ****Owner Enumeration Support:**** Includes a function to retrieve the full list of wallet owners.
* ****Custom Error Usage:**** Uses Solidity custom errors instead of string reverts for lower gas costs.
* ****Transaction Submission Functionality:**** Owners can submit transactions containing: `recipient address`, `ETH amount`, `calldata payload`
* ****Transaction Struct Storage:**** Every transaction is stored permanently in the blockchain using a structured `Transaction` object.
* ****Confirmation Tracking Per Owner:**** Uses nested mappings to track whether a specific owner confirmed a particular transaction.
* ****On-Chain Transaction History:**** All submitted transactions remain stored on-chain for transparency and auditing.
* ****Transaction Count Tracking:**** Includes a helper function to return the total number of submitted transactions.
* ****Decentralized Governance Logic:**** Multiple owners collectively approve actions.

## 🧠 Key Concepts Applied
* ****Structs:**** The `Transaction` struct organizes transaction data into a reusable and efficient storage model.
* ****Enums:**** The `TxState` enum is used for transaction lifecycle management , which are: `Pending`, `Approved`, `Executed`, `Revoked`.
* ****Mappings:**** Key-value storage for efficient lookups. Mappings provide efficient storage and lookup for: `owner validation` and `confirmation tracking`.
* ****Dynamic Arrays:**** Arrays are used to store: `wallet owners`, `submitted transactions`.
* ****Constructor:**** The constructor initializes owners and required confirmation thresholds during deployment.
* ****Event Logging:**** Blockchain logs for off-chain tracking. Events emit blockchain logs for: `deposits`, `submissions`, `confirmations`, `revocations`, `executions`.
* ****Modifiers:**** For Reusable pre-condition checks. It helped reduced repetition, improved code readability, Centralized validation logic.
* ****Ether Handling:**** Receiving and storing ETH. Allows direct ETH transfers into the wallet.
* ****Checks-Effects-Interactions Pattern:**** Security pattern to reduce reentrancy attacks.
* ****State Variables:****  Variables stored  permanently on-chain. Used to Maintain wallet state and Persist transaction records.
* ****Storage:**** Used storage keyword , for permanent blockchain reference.and gas usage.
* ****Function Visibility:**** Used Visibilities like: `public` , `external`. To Controls accessibility and gas usage.
* ****Dynamic Data Type (bytes):**** Arbitrary binary calldata container. This allows function calls, encoded parameters, contract interactions.
* ****View Functions:**** Read-only blockchain access. 

## 📂 Project Structure (Files)
* ****`MultiSignature.sol`****: Main smart contract file containing the complete `Multi-Signature Wallet` logic. </br>
It includes: </br>
  * Owner management.
  * Handles Transaction submission.
  * Handles Transaction confirmation & revocation.
  * Emits events for blockchain activity tracking.
  * Multi-signature approval system.
  * Transaction execution.
  * Security checks, modifiers, events and custom errors.
  * Helper/view functions for reading wallet data. </br>

Purpose: </br>
  Handles all on-chain wallet operations and security rules. 
  
* ****`MultiSignature.t.sol`****: Test file written for validating the smart contract behavior (commonly using `Foundry` framework). </br>
It includes:  </br>
  * Unit tests for all contract functions.
  * Owner validation tests.
  * Tests transaction submission and counting.
  * Tests confirmations and approval flow.
  * Confirmation & execution tests.
  * Tests transaction execution and balance transfers.
  * Revert/error testing.
  * Edge case and security testing. 
  * Verifies expected reverts and edge cases.
 
Purpose: </br>
  Ensures the `MultiSignature.sol` contract works correctly and securely before deployment. 
    
## 🌐Technology Stack  (Technologies Used)
* ****[Solidity](https://www.soliditylang.org/)**** - The programming language for writing the Smart contracts.
* ****[Remix IDE](https://remix.ethereum.org/)**** - used it to write, and deploy the smart contract directly in the browser first.  A fastest way to get started, acting as a "no-setup" workshop for smart contract development.
* ****[Foundry(forge, cast, anvil)](https://www.getfoundry.sh/)**** - Development framework  and testing suite.
* ****[Visual Studio Code](https://code.visualstudio.com/)**** - Install this IDE only if you are using foundry development kit rather than "Remix IDE" which is for quick prototying.

## Getting Started
### Prerequisites
* Solidity Compiler, Version ^0.8.19 or higher.
* `Remix IDE` or `Foundry Development Kit`

### Recommendation  (For Beginners)
****NOTE (Use Remix IDE, for quick prototyping)****:  You can literally just copy the main contract source code and paste it on Remix IDE and learn along side how the code  works while trying to build yours as you keep building. 


## Usage
### Building the Project (Using Remix IDE):
1. Copy the core smart contract file code `MultiSignature.sol` to Remix IDE (a browser based IDE,  for quick prototyping).
2. Create a new file for the project on your Remix IDE and paste , to learn and build along faster.
3. And then Compile  the smart contract file you have created on Remix IDE.

### Building the Project (Using Foundry Development Kit ) - only if you are good using foundry kit
1. Clone the repository: </br>
   ```shell
       git clone https://github.com/legendarycode3/multisig-smart-contract
   ```
2. Navigate to the directory you created and cloned the file to:
   ```shell
       cd multisig-smart-contract
   ```
3. Compile the smart contract: `forge build`

### Testing the contract  (Using Foundry Development Kit )
Runing all tests: </br>
    ```shell
        forge test
    ```
 Runing specific test:
   ```shell
         forge test --mt testFunctionName
   ```

## 📋Contract Details
### Functions:
* ****`constructor(address[] memory _owners, uint256 _numConfirmationsRequired)`****: Initializes the multi-signature wallet. It Registers wallet owners and Sets the minimum confirmations required.
* ****`receive()`****: Allows the contract to receive Ether directly. It Accepts ETH sent to the contract and emits a `Deposit` event.
* ****`submitTransaction(address _to, uint256 _value, bytes memory _data)`****: Creates a new transaction proposal. Only wallet owners can call it.
* ****`confirmTransaction(uint256 _txIndex)`****:  Allows owners only to Confirm / approve a transaction.
* ****`executeTransaction(uint256 _txIndex)`****: Executes an approved transaction. This is the function that actually transfers funds. Only owners can execute this. The function "Verifies if enough confirmations exist", "Verifies contract has enough ETH", "Marks transaction as `Executed`" and "Performs low-level external call".
* ****`revokeConfirmation(uint256 _txIndex)`**** Revokes a previously submitted confirmation. Allows `onlyOwner` to remove their approval and Cannot revoke if never approved (transaction must exist).
* ****`getTransactionCount()`****: Returns the total number of submitted transactions.
* ****`getTransaction(uint256 _txIndex)`:**** Returns complete information about a transaction. Useful for "Transaction tracking", "Blockchain explorers"and  "Offchain dashboards".
* ****`getOwners()`****: Returns all registered wallet owners.

### Variables:
* ****`s_owners`****: Stores the list of all authorized wallet owners. It is a Dynamic type array of addresses. It practically Keeps track of every address allowed to: "submit transactions", "confirm transactions", "execute transactions" , "revoke confirmations".
* ****`s_isOwner`****: Helps quickly checks whether an address is an authorized owner. It Maps from address → boolean (Best for providing fast owner verification).
* ****`s_numConfirmationsRequired`****: Defines the minimum number of approvals needed before a transaction can be executed (by the entire wallet owners).  This is the core security threshold of the wallet. This variable determines: "Wallet decentralization", "Security level" , "Consensus requirement" for the multi-signature wallet.
* ****`s_transactions`****: Stores all submitted transaction proposals. It transaction type is a Dynamic array of `Transaction` structs. Stores every submitted transaction, whenever an owner proposes a transaction.
* ****`s_isConfirmed`****: Tracks which owners confirmed which transactions. This mechanism practical used, prevents "duplicate confirmations", "unauthorized revocations".
* ****`TxState`****: Enum Variable Type, defines all possible transaction states ( `Pending`, `Approved`, `Executed`, `Revoked`). The `Pending` state simply means "Waiting for confirmations". The `Approve` state simply means "Enough confirmations received". The `Executed` state simply means "Transaction completed". The `Revoked` state simply means "Confirmation withdrawn".


## Why This Matters (Multi Signature Wallet Smart Contract)
Multi-signature (MultiSig) smart contracts matter in Web3 because they require two or more cryptographic keys to authorize a single blockchain transaction. Unlike standard single-key wallets (EOAs),  they distribute control and eliminate  single points of failure, making them the industry standard for securing large treasuries and institutional assets. </br>

Here is why MultiSig smart contracts are critical to the Web3 ecosystem: </br>
1. ****Eliminates Single Points of Failure:****  In a standard wallet, if your private key is lost or compromised by a hacker, your funds are gone. With a MultiSig wallet, an attacker must compromise multiple specific devices or keys to access the assets.
2. ****Prevents Unauthorized Drains & Theft:**** Even if you accidentally click a maliciouss link or approve a bad signature in a phishing attack,  hackers cannot drain the wallet without the required threshold of additional approvals.
3. ****Enables Shared Ownership and DAOs:****  Web3 requires collaborative decision-making. MultiSigs enforce collective control, allowing teams, businesses, or Decentralized Autonomous Organizations (DAOs)  to manage shared funds transparently.
4. ****Mitigates Human Error:**** They act as a digital safety net. A MultiSig contract can be set up so that one person initiates a transaction,  but the majority of the team or board must sign off on it. This prevents accidental transfers or rogue employee actions.
5. ****Provides Trustless Escrow & Dispute Resolution:****  MultiSigs are commonly configured with an M-of-N scheme.
6. ****Prevents Accidental Fund Transfers:**** Transactions require review before execution, reducing mistakes.
7. ****Improves Security:**** Multiple approvals are required before transactions execute, making unauthorized transfers much harder.
8. ****Builds Trust Among Team Members:**** No single individual has complete control over organizational assets.
9. ****Represents Core Web3 Principles:**** MultiSig wallets embody decentralization, transparency, shared ownership, and trust minimization within blockchain ecosystems.


## Common Key UseCases of `Multi-Signature` Smart Contracts
Here are the most common use cases:
1. ****Treasury Management for DAOs:**** A decentralized autonomous organization (DAO) often stores community funds in a multisig wallet so that no single person can move funds alone. Simply , Multisig wallets is used to manage treasury.
2. ****Corporate Crypto Asset Custody:****  Companies holding cryptocurrency often use multisig contracts for operational security.
3. ****Escrow Services:**** Multisig contracts are commonly used in trustless escrow systems.
4. ****Joint Accounts / Shared Ownership:**** Multisig contracts work like blockchain joint bank accounts.
5. ****DeFi Protocol Governance:**** Many decentralized finance protocols protect administrative functions with multisig contracts.
6. ****Smart Contract Upgrade Authorization:**** Upgradeable smart contracts often require multisig approval before: "deploying upgrades", "changing implementation addresses",


## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of (Some include):

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).

## Documentation

https://book.getfoundry.sh/

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```
