# Restaking Flow Simulation — Lido, wstETH, Aave, RestakeManager

This mini-project simulates the Ethereum restaking flow using simplified mock contracts:
Stake ETH → receive stETH → wrap to wstETH → supply to Aave.  
The goal is to understand how assets move between protocols and how real functions behave.

---

# Real vs Mock Contract Function Notes

## Lido — submit() / deposit()
In real Lido, submit() accepts ETH, stakes it through validators, and mints stETH 1:1. stETH is a rebasing token whose balance increases over time as rewards accumulate.  
In our mock deposit(), ETH is simply received and the same amount of stETH is minted, without staking rewards or validator logic.

## WstETH — wrap()
Real wstETH wraps rebasing stETH into a fixed-supply ERC20 using a dynamic exchange rate based on total pooled ETH. wstETH itself does not rebase.  
Our mock wrap() only converts stETH into wstETH proportionally, without implementing exchange-rate changes or reward mechanics.

## Aave — supply()
On Aave, supply() deposits an ERC20 asset, updates collateral configuration, mints interest-bearing aTokens, and interacts with the risk engine to ensure health factor safety.  
In the mock supply(), the protocol simply transfers the token and mints the same amount of mock aTokens, without interest or risk checks.

## Aave — withdraw()
Aave’s withdraw() burns aTokens and returns the equivalent amount of the underlying asset while checking that the user’s health factor remains safe.  
Our mock withdraw() only burns the mock aTokens and transfers back the underlying token, with no collateral or solvency checks.

## RestakeManager
In real DeFi, users normally perform staking → wrapping → supplying manually unless using an aggregator.  
Our RestakeManager automates all steps in one transaction: deposits ETH into Lido, wraps the resulting stETH, and supplies the wstETH into the mock Aave protocol.

---

# Contracts Included
- Lido.sol — mock staking (ETH → stETH)
- WstETH.sol — mock wrapper (stETH → wstETH)
- Aave.sol — mock lending protocol
- RestakeManager.sol — orchestrator contract automating the full flow
  
---

# Authors (Solo)
- Kelvin Lie
