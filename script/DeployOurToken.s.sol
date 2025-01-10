// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";
import {OurToken} from "../src/OurToken.sol";

contract DeployOurToken is Script {
    function run() external returns (OurToken) {
        vm.startBroadcast();
        OurToken ourToken = new OurToken();
        vm.stopBroadcast();
        return ourToken;
    }
}
