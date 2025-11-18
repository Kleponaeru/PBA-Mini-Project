// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

contract Aave is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    mapping(address => address) public aTokens;

    constructor() Ownable(msg.sender) {}

    function registerAToken(address token, address aToken) external onlyOwner {
        aTokens[token] = aToken;
    }

    function supply(address token, uint256 amount) external nonReentrant {
        address aToken = aTokens[token];
        require(aToken != address(0), "aToken not registered");

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        MockAToken(aToken).mint(msg.sender, amount);
    }

    function withdraw(address token, uint256 amount) external nonReentrant {
        address aToken = aTokens[token];
        require(aToken != address(0), "aToken not registered");

        MockAToken(aToken).burnFrom(msg.sender, amount);
        IERC20(token).safeTransfer(msg.sender, amount);
    }
}

contract MockAToken is ERC20, Ownable {
    constructor(
        string memory n,
        string memory s
    ) ERC20(n, s) Ownable(msg.sender) {}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burnFrom(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
