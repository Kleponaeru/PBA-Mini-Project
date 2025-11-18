// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

interface ILido {
    function deposit() external payable returns (uint256);
}

interface IWstETH {
    function wrap(uint256 amount) external returns (uint256);
}

interface IAave {
    function supply(address token, uint256 amount) external;
}

contract RestakeManager is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    ILido public immutable lido;
    address public immutable stETH;
    IWstETH public immutable wstETH;
    IAave public immutable aave;

    constructor(address _lido, address _stEth, address _wstEth, address _aave) Ownable(msg.sender) {
        lido = ILido(_lido);
        stETH = _stEth;
        wstETH = IWstETH(_wstEth);
        aave = IAave(_aave);
    }

    function depositWrapLend() external payable nonReentrant {
        uint256 minted = lido.deposit{value: msg.value}();

        IERC20(stETH).approve(address(wstETH), minted);
        uint256 wst = wstETH.wrap(minted);

        IERC20(address(wstETH)).approve(address(aave), wst);
        aave.supply(address(wstETH), wst);
    }

    receive() external payable {}
}
