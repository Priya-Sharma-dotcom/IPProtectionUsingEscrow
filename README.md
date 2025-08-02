# Intellectual Property Smart Contract

This Solidity smart contract enables users to register and trade intellectual properties (IP) — including Patents, Copyrights, and Trademarks — on the Ethereum blockchain. It includes features such as royalty-based resale logic and secure transfer of ownership.

---

## 🔑 Features

* IP Registration (by any user)
* IP Types: Patent, Copyright, Trademark
* Secure Purchase Workflow
* Refund Mechanism for Pending Buyers
* **Royalty System**: 10% of resale price goes to the original IP creator on every resale
* Automatic Price Increase After Each Transfer (+0.5 ETH)
* Admin-only access to certain actions (if extended)

---

## 📄 Smart Contract Summary

### Structs

```solidity
struct IP {
  string name;
  string description;
  IpType ipType;
  address currentOwner;
  address creator;
  address[] owners;
  bool registered;
  uint price;
}
```

### Enums

```solidity
enum IpType { Patent, Copyright, Trademark }
```

### Key Functions

* `registerIP(...)` — Register new IP (sets caller as `creator`)
* `buyIP(id)` — Buyer sends exact `price` in ETH
* `transferIP(id)` — Called by current owner to transfer IP and pay royalty to creator
* `refundToBuyer(id)` — Allows buyer to withdraw if seller doesn't approve
* `getIPInfo(id)` — Returns all metadata of the IP
* `getCreator(id)` — Returns original creator of the IP

---

## 💸 Royalty System

On every resale:

* **10%** of sale price is transferred to the original `creator`
* **90%** goes to the current seller

---

## 🚀 Deployment

Ensure you have the following:

* Solidity ^0.8.0
* Ethereum wallet (e.g., MetaMask)
* Remix IDE or Truffle/Hardhat setup

### Steps

1. Deploy contract to Ethereum testnet or local Ganache
2. Use `registerIP()` to create a new IP
3. Another address can call `buyIP()` with correct ETH amount
4. Seller calls `transferIP()` to complete sale and trigger royalty payment

---

## ✅ Example Workflow

```solidity
// Account A registers an IP
registerIP("My Invention", "A novel idea", IpType.Patent, 1 ether);

// Account B buys it by sending 1 ether
buyIP(1);

// Account A calls transferIP to approve sale
transferIP(1);

// Creator (A) gets 0.1 ETH royalty, Seller (A) gets 0.9 ETH
// B becomes new owner, price becomes 1.5 ETH
```

---

## 🧪 Testing Tips

* Try registering from multiple accounts
* Observe royalty behavior after multiple transfers
* Use `getIPInfo(id)` to check ownership and price

---

## 📬 License

MIT
