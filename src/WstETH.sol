// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

interface IStETH is IERC20 {}

contract WstETH is ERC20, Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public immutable stETH;

    constructor(address _stETH) ERC20("Wrapped stETH", "wstETH") Ownable(msg.sender) {
        require(_stETH != address(0), "zero stETH");
        stETH = IERC20(_stETH);
    }

    function wrap(uint256 amount) external nonReentrant returns (uint256) {
        require(amount > 0, "zero amount");

        uint256 totalStaked = stETH.balanceOf(address(this));
        uint256 totalShares = totalSupply();

        stETH.safeTransferFrom(msg.sender, address(this), amount);

        uint256 shares;
        if (totalShares == 0 || totalStaked == 0) {
            shares = amount;
        } else {
            shares = (amount * totalShares) / totalStaked;
        }

        _mint(msg.sender, shares);
        return shares;
    }

    function unwrap(uint256 shares) external nonReentrant returns (uint256) {
        require(shares > 0, "zero shares");

        uint256 totalShares = totalSupply();
        uint256 totalStaked = stETH.balanceOf(address(this));

        require(totalShares > 0 && totalStaked > 0, "no liquidity");

        uint256 amount = (shares * totalStaked) / totalShares;

        _burn(msg.sender, shares);
        stETH.safeTransfer(msg.sender, amount);

        return amount;
    }

    function rescueToken(address token, address to, uint256 amount) external onlyOwner {
        IERC20(token).safeTransfer(to, amount);
    }
}
