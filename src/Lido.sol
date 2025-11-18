// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

contract StETH is ERC20 {
    constructor() ERC20("Mock stETH", "stETH") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract Lido is Ownable, ReentrancyGuard {
    StETH public stETH;

    constructor() Ownable(msg.sender) {
        stETH = new StETH();
    }

    /// @notice stake ETH → mint stETH 1:1
    function deposit() external payable nonReentrant returns (uint256) {
        require(msg.value > 0, "Must send ETH");
        stETH.mint(msg.sender, msg.value);
        return msg.value;
    }

    receive() external payable {}
}
