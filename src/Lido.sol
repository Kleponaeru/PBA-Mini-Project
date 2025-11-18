// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {
    ERC20
} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {
    Ownable
} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {
    ReentrancyGuard
} from "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

contract StETH is ERC20 {
    constructor() ERC20("Mock stETH", "stETH") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract Lido is Ownable, ReentrancyGuard {
    StETH public stEth;

    constructor() Ownable(msg.sender) {
        stEth = new StETH();
    }

    /// @notice stake ETH → mint stETH 1:1
    function deposit() external payable nonReentrant returns (uint256) {
        require(msg.value > 0, "Must send ETH");
        stEth.mint(msg.sender, msg.value);
        return msg.value;
    }

    receive() external payable {}
}
