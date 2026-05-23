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
* ****Owner Enumeration Support:****
* ****Custom Error Usage:**** Uses Solidity custom errors instead of string reverts for lower gas costs.
* ****Transaction Submission Functionality:**** Owners can submit transactions containing: `recipient address`, `ETH amount`, `calldata payload`
* ****Transaction Struct Storage:**** Every transaction is stored permanently in the blockchain using a structured `Transaction` object.
* ****Confirmation Tracking Per Owner:**** Uses nested mappings to track whether a specific owner confirmed a particular transaction.
* ****On-Chain Transaction History:**** All submitted transactions remain stored on-chain for transparency and auditing.
* ****Transaction Count Tracking:**** Includes a helper function to return the total number of submitted transactions.

## 🧠 Key Concepts Applied

## 🌐Technology Stack  (Technologies Used)
* ****[Solidity](https://www.soliditylang.org/)**** - The programming language for writing the Smart contracts.
* ****[Remix IDE](https://remix.ethereum.org/)**** - used it to write, and deploy the smart contract directly in the browser first.  A fastest way to get started, acting as a "no-setup" workshop for smart contract development.
* ****[Foundry(forge, cast, anvil)](https://www.getfoundry.sh/)**** - Development framework  and testing suite.
* ****[Visual Studio Code](https://code.visualstudio.com/)**** - Install this IDE only if you are using foundry development kit rather than "Remix IDE" which is for quick prototying.

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
