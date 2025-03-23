// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;




import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import{CrowdFunding} from "../src/crowdFunding.sol";
import {CrowdFundScript} from "../script/crowdFunding.s.sol";



contract CrowdFundTest is Test{

    CrowdFundScript deploy;
    CrowdFunding system;

    address user1=address(2);
    address user2=address(3);
    address user3=address(4);
    address user4=address(5);
    address user5=address(6);
    address Owner;
    uint256 decimal;

    function setUp()public{
        deploy= new CrowdFundScript();
        system=deploy.runSystem();
        Owner=system.GetOwner();
        decimal=system.getDecimal();
    }


    function testpaticipate()public{
        vm.deal(user1,10e18);
        vm.prank(user1);
        system.participate{value : 5e17}();

        assertEq(system.GetFunder(0),user1);
        assertEq(system.getRaisedAmount(),5e17);
        assertEq(system.getAmountAUserFounded(user1),5e17);
    }
    function testParticipateforSecondTimeFails()public{

        vm.deal(user1,10e18);
        vm.startPrank(user1);
        system.participate{value : 5e17}();
        vm.expectRevert(CrowdFunding.CrowdFunding_YouhaveParticipateBefore.selector);
        system.participate{value : 4e17}();
        vm.stopPrank();


    }
    function testParticipateReverts()public{
        vm.deal(user1,10e18);
    
        vm.startPrank(user1);
        vm.expectRevert(CrowdFunding.CrowdFunding_YouShouldSendSomeEtherum.selector);
        system.participate{value : 0}();
        vm.stopPrank();

        vm.warp(block.timestamp+system.getDeadLine()+system.getInitialTime());
        vm.startPrank(user1);
        vm.expectRevert(CrowdFunding.CrowdFunding_CampaignIsOver.selector);
        system.participate{value : 4e17}();
        vm.stopPrank();

    }
    function testRefund()public{
        vm.deal(user1,10e18);
        vm.prank(user1);
        system.participate{value : 5e17}();

        vm.warp(block.timestamp+system.getDeadLine()+system.getInitialTime());
        vm.startPrank(user1);
        system.refund();
        vm.stopPrank();

        assertEq(system.getAmountAUserFounded(user1),0);
        assertEq(user1.balance,10e18);
        
    }
    function testRefundReverts()public{
        vm.deal(user1,10e18);
        vm.prank(user1);
        system.participate{value : 5e17}();

        vm.warp(block.timestamp+system.getDeadLine()+system.getInitialTime());
        vm.startPrank(user1);
        system.refund();
        vm.stopPrank();

        vm.startPrank(user1);
        vm.expectRevert(CrowdFunding.CrowdFunding_YouHaveRefundedBefore.selector);
        system.refund();
        vm.stopPrank();

    }
    function testWithdraw()public{
        vm.deal(Owner,0);
        vm.deal(user1,10*10e18);
        vm.prank(user1);
        system.participate{value : 10*10e18}();

        vm.warp(block.timestamp+system.getDeadLine()+system.getInitialTime());
        vm.startPrank(Owner);
        system.withdraw();
        vm.stopPrank();

        assertEq(Owner.balance,10*10e18);
    }

    function testRefundAll()public{
        vm.deal(user1,10e18);
        vm.prank(user1);
        system.participate{value : 5e17}();

        vm.deal(user2,10e18);
        vm.prank(user2);
        system.participate{value : 5e17}();

        vm.deal(user3,10e18);
        vm.prank(user3);
        system.participate{value : 5e17}();

        vm.warp(block.timestamp+system.getDeadLine()+system.getInitialTime());
        vm.startPrank(Owner);
        system.RefundAll();
        vm.stopPrank();


        assertEq(system.getRaisedAmount(),3*5e17);
        assertEq(user1.balance,10e18);
        assertEq(user2.balance,10e18);
        assertEq(user3.balance,10e18);


    }

    function testReceiveAndFallback()public{
        vm.deal(user1,10e18);
        vm.prank(user1);
        (bool Success, )=address(system).call{value : 5e17}("");
        assertEq(system.GetFunder(0),user1);
        assertEq(system.getRaisedAmount(),5e17);
        assertEq(system.getAmountAUserFounded(user1),5e17);
        assertTrue(Success);

        vm.deal(user2,10e18);
        vm.prank(user2);
        (bool Successs, )=address(system).call{value : 5e17}("enter");
        assertEq(system.GetFunder(1),user2);
        assertEq(system.getRaisedAmount(),10e17);
        assertEq(system.getAmountAUserFounded(user2),5e17);
        assertTrue(Successs);
    }
    



}