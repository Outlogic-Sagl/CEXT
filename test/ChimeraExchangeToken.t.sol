// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {ChimeraExchangeToken} from "src/ChimeraExchangeToken.sol";

contract ChimeraExchangeTokenTest is Test {
  ChimeraExchangeToken public token;

    address owner = address(0x1);
    address user = address(0x2);
    address vault = address(0x3);

    uint256 constant INITIAL_SUPPLY = 1_000_000_000 ether;

  function setUp() public {
    token = new ChimeraExchangeToken(
            owner);
  }

  function testName() public view {
    assertEq(token.name(), "Chimera Exchange Token");
  }

  function testInitialBalanceAssignedToOwner() public {
      assertEq(token.balanceOf(owner), INITIAL_SUPPLY);
      assertEq(token.totalSupply(), INITIAL_SUPPLY);
  }

  function testUserDeposit() public {
    uint256 depositAmount = 1_000 ether;

    // Owner sends tokens to user
    vm.prank(owner);
    token.transfer(user, depositAmount);

    // User deposits tokens to vault
    vm.prank(user);
    token.transfer(vault, depositAmount);

    assertEq(token.balanceOf(user), 0);
    assertEq(token.balanceOf(vault), depositAmount);
  }

    /*//////////////////////////////////////////////////////////////
                        WITHDRAW (TRANSFER BACK)
    //////////////////////////////////////////////////////////////*/

    function testWithdraw() public {
      uint256 depositAmount = 1_000 ether;

      // Setup: owner -> user -> vault
      vm.startPrank(owner);
      token.transfer(user, depositAmount);
      vm.stopPrank();

      vm.startPrank(user);
      token.transfer(vault, depositAmount);
      vm.stopPrank();

      // Withdraw: vault -> user
      vm.prank(vault);
      token.transfer(user, depositAmount);

      assertEq(token.balanceOf(vault), 0);
      assertEq(token.balanceOf(user), depositAmount);
    }

    /*//////////////////////////////////////////////////////////////
                    FAILING CASES (SAFETY)
    //////////////////////////////////////////////////////////////*/

    function testCannotWithdrawMoreThanBalance() public {
      vm.prank(vault);
      vm.expectRevert();
      token.transfer(user, 1 ether);
    }

    function testCannotDepositMoreThanBalance() public {
      vm.prank(user);
      vm.expectRevert();
      token.transfer(vault, 1 ether);
    }
}
