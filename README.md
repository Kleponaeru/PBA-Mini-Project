## **Lido — `deposit()`**

In the real Lido protocol, the `submit()` (or `deposit()`) function accepts ETH and mints stETH 1:1 to the user. The ETH is then delegated to validators and the stETH balance grows over time through rebasing.
In our mock `deposit()` implementation, we replicate only the basic behavior: ETH is received and the same amount of stETH is minted to the sender, without validator delegation or rebasing logic.

---

## **Aave — `supply()`**

In real Aave, the `supply()` function deposits an ERC20 token into the protocol, updates the user’s collateral position, and mints aTokens that represent their interest-bearing balance. The system also tracks health factors, collateral ratios, and liquidation rules.
In our mock `supply()` function, we simply transfer the token from the user and mint a 1:1 mock aToken, without interest, collateral checks, or risk engine logic.

---

## **Aave — `withdraw()`**

In Aave, `withdraw()` burns the user’s aTokens and returns the equivalent amount of the underlying asset, while also verifying that the user’s health factor remains safe after withdrawal.
Our mock `withdraw()` only burns the user’s mock aTokens and sends back the exact amount of underlying tokens — no health factor checks, no collateral management, and no interest calculations.

---

## **WstETH — `wrap()`**

Real wstETH wraps rebasing stETH into a non-rebasing ERC20 using a dynamic exchange rate derived from Lido’s total pooled ETH.
In our mock `wrap()` function, we mimic this behavior by calculating shares based on totalSupply vs total stETH in the contract, but we do not implement real exchange rate changes or rebase mechanics.

---

## **RestakeManager**

The real-world flow (stake → wrap → lend) is typically performed manually or via integrations.
Our RestakeManager contract replicates this pipeline by automatically calling Lido’s `deposit()`, then wrapping stETH into wstETH, and finally supplying the wstETH into the mock Aave protocol in a single transaction.

---
