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

        // Deploy Lido and StETH
        Lido lido = new Lido();

        // Deploy WstETH, pass the address of stEth variable from Lido
        WstETH wstEth = new WstETH(address(lido.stEth.address));

        // Deploy Aave and a mock aToken
        Aave aave = new Aave();
        MockAToken aStETH = new MockAToken("Aave stETH", "astETH");

        // Register aToken with Aave and transfer ownership
        aave.registerAToken(address(lido.stEth.address), address(aStETH));
        aStETH.transferOwnership(address(aave));

        // Deploy RestakeManager with all contract addresses
        new RestakeManager(
            address(lido),
            address(lido.stEth.address),
            address(wstEth),
            address(aave)
        );

        vm.stopBroadcast();
    }
}
