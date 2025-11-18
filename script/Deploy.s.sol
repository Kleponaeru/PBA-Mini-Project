// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/Lido.sol";
import "../src/WstETH.sol";
import "../src/Aave.sol";
import "../src/RestakeManager.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        Lido lido = new Lido();
        WstETH wstEth = new WstETH(address(lido.stETH()));

        Aave aave = new Aave();
        MockAToken aStETH = new MockAToken("Aave stETH", "astETH");

        aave.registerAToken(address(lido.stETH()), address(aStETH));
        aStETH.transferOwnership(address(aave));

        new RestakeManager(
            address(lido),
            address(lido.stETH()),
            address(wstEth),
            address(aave)
        );

        vm.stopBroadcast();
    }
}
