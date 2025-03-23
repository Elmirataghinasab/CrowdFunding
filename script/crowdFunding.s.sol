// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Script, console} from "forge-std/Script.sol";
import{CrowdFunding} from "../src/crowdFunding.sol";

contract CrowdFundScript is Script{
    function runSystem()external returns (CrowdFunding){
        vm.startBroadcast();
        CrowdFunding crowdfunding=new CrowdFunding();
        vm.stopBroadcast();

        return crowdfunding;
    }
}