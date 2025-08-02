# 🧠 Intellectual Property (IP) Marketplace Smart Contract

This Solidity smart contract allows the **registration**, **purchase**, and **ownership transfer** of Intellectual Property assets such as **Patents**, **Copyrights**, and **Trademarks**.

---

## 📘 Contract Name

```solidity
IPContract
```

---

## 🧑‍⚖️ Roles

* **Admin**: Deployer of the contract; has exclusive rights to register IPs.
* **User**: Anyone interested in buying an IP asset.

---

## 📦 IP Structure

Each IP entry contains:

* `name`: IP title
* `description`: Description of the IP
* `ipType`: Enum (Patent, Copyright, Trademark)
* `currentOwner`: Ethereum address of current owner
* `owners`: History of all past and current owners
* `registered`: Boolean flag indicating if the IP is registered
* `price`: Current price in wei (1 ether = 10¹⁸ wei)

---

## 🔧 Core Features

### ✅ Register IP

```solidity
function registerIP(string memory _name, string memory _description, IpType _ipType, uint _price) public OnlyAdmin
```

* Only admin can register a new IP.
* Automatically assigns a unique ID.

---

### 💰 Buy IP

```solidity
function buyIP(uint id) public payable
```

* Buyer sends exact ETH equal to `price`.
* Marks buyer as pending until seller approves.

---

### 📦 Transfer Ownership

```solidity
function transferIP(uint id) public OnlyCurrentOwner(id)
```

* Current owner approves transfer.
* ETH is released to seller.
* Ownership updated and price increases by 0.5 ether.

---

### ❌ Refund Buyer

```solidity
function refundToBuyer(uint id) public
```

* Pending buyer can withdraw if transfer not complete.

---

### 📰 View IP Info

```solidity
function getIPInfo(uint id) public view returns (...)
```

* Returns metadata: name, description, ipType, currentOwner, past owners, price.

---

### 🧐 Get Current Owner

```solidity
function getCurrentOwner(uint id) public view returns (address)
```

---

## 🔄 Events

* `IpAdded(uint id, address indexed currentOwner)`
* `BuyerPaid(uint amount, address indexed buyer)`
* `OwnershipTransferred(uint id, address indexed newOwner)`
* `RefundIssued(uint id, uint amount, address indexed buyer)`

---

## 🔐 Security

* Only Admin can register IPs.
* Only current owner can transfer.
* Buyer refund is protected and clear.

---

## ⚖️ Enum Type

```solidity
enum IpType { Patent, Copyright, Trademark }
```

---

## 🌐 Deployment

* Deploy using Remix, Hardhat, or Truffle.
* Set constructor `msg.sender` as the Admin.

---

## 📢 Future Enhancements

* Add royalty-based resale
* Auction system for IPs
* IP verification via documents or oracles
* NFT integration for unique IP representation

---

**Made with ❤️ for IP innovation on Ethereum**
