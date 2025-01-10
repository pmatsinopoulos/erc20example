// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

uint256 constant STARTING_BALANCE = 100 ether;

contract OurTokenTest is Test {
    OurToken ourToken;
    DeployOurToken deployOurToken;

    address account;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() public {
        console.log("setup(): msg.sender:", msg.sender); // the default 0x184
        account = msg.sender;
        console.log("setup(): this.address:", address(this));

        // we deploy a new contract. The deployer is the `msg.sender` who is the default
        // 0x1804 address in foundry
        deployOurToken = new DeployOurToken();
        ourToken = deployOurToken.run(); // since +run()+ does not change the sender
        // in its implementation, +ourToken+ is being deployed with +msg.sender+ being
        // the default `msg.sender`, i.e. the 0x1804 address

        // - if we just call +transfer+ the `msg.sender` is the `OurTokenTest` address,
        // which doesn't have balance. When we call another contract from the contract,
        // inside that other contract call, the `msg.sender` is the calling contract.
        // - If we do `vm.prank(address(deployOurToken))` first, this will fail
        // again, because the `deployOurToken` doesn't have the initial supply.
        // - Only if we prank the default address 0x1804 it will succeed
        vm.prank(account);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function test_bobBalance() public {
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    function test_allowances() public {
        // bob will approve +account+ to transfer some amount to alice
        uint256 amount = 10 ether;
        vm.prank(bob);
        ourToken.approve(account, amount);

        vm.prank(account);
        ourToken.transferFrom(bob, alice, 5 ether);

        assertEq(ourToken.balanceOf(alice), 5 ether);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - 5 ether);

        vm.prank(account);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector,
                account,
                5 ether,
                20 ether
            )
        );
        ourToken.transferFrom(bob, alice, 20 ether);
    }
}
