# Multi Signature Wallet Smart Contract

## Project Overview

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

## 🧠 Key Concepts Applied
* ****Structs:**** The `Transaction` struct organizes transaction data into a reusable and efficient storage model.
* ****Enums:**** The `TxState` enum is used for transaction lifecycle management , which are: `Pending`, `Approved`, `Executed`, `Revoked`.
* ****Mappings:**** Key-value storage for efficient lookups. Mappings provide efficient storage and lookup for: `owner validation` and `confirmation tracking`.
* ****Dynamic Arrays:**** Arrays are used to store: `wallet owners`, `submitted transactions`.
* ****Constructor:**** The constructor initializes owners and required confirmation thresholds during deployment.
* ****Event Logging:**** Blockchain logs for off-chain tracking. Events emit blockchain logs for: `deposits`, `submissions`, `confirmations`, `revocations`, `executions`.
* ****Modifiers:**** For Reusable pre-condition checks. It helped reduced repetition, improved code readability, Centralized validation logic.
* ****Ether Handling:**** Receiving

## 🌐Technology Stack  (Technologies Used)
* ****[Solidity](https://www.soliditylang.org/)**** - The programming language for writing the Smart contracts.
* ****[Remix IDE](https://remix.ethereum.org/)**** - used it to write, and deploy the smart contract directly in the browser first.  A fastest way to get started, acting as a "no-setup" workshop for smart contract development.
* ****[Foundry(forge, cast, anvil)](https://www.getfoundry.sh/)**** - Development framework  and testing suite.
* ****[Visual Studio Code](https://code.visualstudio.com/)**** - Install this IDE only if you are using foundry development kit rather than "Remix IDE" which is for quick prototying.

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
