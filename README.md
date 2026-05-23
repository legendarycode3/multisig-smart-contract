# Multi Signature Wallet Smart Contract

## Project Overview

## 📌 Features
* ****Multi-Owner Wallet Support:**** Supports multiple wallet owners. Tracks authorized signers and prevents unauthorized access.
* ****Custom Confirmation Threshold:**** During deployment, the contract allows setting the minimum number of confirmations required before executing a transaction.
* ****Owner Validation on Deployment:**** Prevents deployment with invalid owner addresses such as the zero address.
* ****Ether Deposit Support:**** Contract can receive ETH directly. Emits deposit events and Tracks updated balance.
* ****Duplicate Owner Prevention:**** Ensures the same owner address cannot be added more than once.

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
