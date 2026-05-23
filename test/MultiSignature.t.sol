// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {MultiSignature} from "../src/MultiSignature.sol";


contract MultiSignatureTest is Test {

    MultiSignature multisignature;

    /// @notice Generating deterministic addresses
    address  owner1 = makeAddr("owner1");
    address owner2 = makeAddr("owner2");
    address owner3 = makeAddr("owner3");

    address user = makeAddr("user");

    uint256 constant REQUIRED_CONFIRMATIONS = 2;

    
    /// @notice Initializes the testing environment for the MultiSignature wallet
    function setUp() public {

        // Initialize the array with size 2
        address[] memory ownersAddress = new address[](3); 
        
        // Assign the addresses
        ownersAddress[0] = owner1;
        ownersAddress[1] = owner2;
        ownersAddress[2] = owner3;

        //  Deploy the contract with the array and the uint256 threshold
        multisignature = new MultiSignature(ownersAddress, REQUIRED_CONFIRMATIONS);


        //  Forcefully injects 10 Ether directly into the deployed multisignature contract's balance()
        vm.deal(address(multisignature), 10 ether);
    }




    /*//////////////////////////////////////////////////////////////
                               SUBMIT FUNCTION
    //////////////////////////////////////////////////////////////*/

    /// @notice Verifies that an owner can submit a pending transaction
    function testSubmitTransaction() public {
                // == ARRANGE ==
        
        // Prepare the execution context by faking the message sender, to be "owner1" using the Foundry vm.prank cheat code.
        vm.prank(owner1);

                // == ACT ==

        // Submit a new transaction proposal to the multisignature contract, with the target address, value, and an empty data payload.
        multisignature.submitTransaction(
            user, 
            1 ether,
            ""
        );

        // Fetch the newly created transaction details from storage at index 0.
        ( address to, uint256 value, bytes memory data, uint256 numConfirmations, MultiSignature.TxState state
        ) = multisignature.getTransaction(0);

        // Verify that the stored transaction data exactly matches the submitted values,
        // that there are currently 0 confirmations, and that the state is "Pending".
        assertEq(to, user);
        assertEq(to, user);
        assertEq(value, 1 ether);
        assertEq(data, "");
        assertEq(numConfirmations, 0);
        assertEq(uint256(state), uint256(MultiSignature.TxState.Pending));
    }

    /// @notice Verifies that transaction count increments correctly
    function testTransactionCountIncreases() public {
                // == ARRANGE ==
        
        // Set the `msg.sender` to `owner1` for all subsequent calls.
        vm.startPrank(owner1);

        // Submit the first transaction: sending 1 ether to `user`.
        multisignature.submitTransaction(user, 1 ether, "");

        // Submit the second transaction: sending 2 ether to `user`.
        multisignature.submitTransaction(user, 2 ether, "");

        // Revert the `msg.sender` back to the default test contract address.
        vm.stopPrank();
                
                // == ACT ==
        // Check if the total transaction count in the contract equals 2.
        // If it fails, the provided error message will display.
        assertEq(multisignature.getTransactionCount(), 2, "Transaction count did not increase to 2, Failed");
    }




    /*//////////////////////////////////////////////////////////////
                             CONFIRM FUNCTION
    //////////////////////////////////////////////////////////////*/
    function testConfirmTransaction() public {
                // == ARRANGE ==
        
        // Impersonate owner1 to submit a new transaction transferring 1 ether to the user
        vm.prank(owner1);
        multisignature.submitTransaction(user, 1 ether, "");

                // == ACT ==

        // Impersonate owner1 again to confirm the newly created transaction (index 0)
        vm.prank(owner1);
        multisignature.confirmTransaction(0);

                // == ASSERT ==

          // Fetch the transaction details from the smart contract
        (
            ,
            ,
            ,
            uint256 numConfirmations,
            MultiSignature.TxState state
        ) = multisignature.getTransaction(0);

        // Verify the transaction now has exactly 1 confirmation
        assertEq(numConfirmations, 1);

        // Verify the transaction now has exactly 1 confirmation
        assertEq(uint256(state), uint256(MultiSignature.TxState.Pending));
    }


    /// @notice Verifies that a multi-signature transaction successfully transitions to the Approved state once it reaches the required number of confirmations.
     function testTransactionBecomesApprovedAfterRequiredConfirmations() public {
                // == ARRANGE (Set up the initial state and transaction) == 
        
        // Owner 1 submits a new transaction of 1 ether to the user
        vm.prank(owner1);
        multisignature.submitTransaction(user, 1 ether, "");

                // == ACT (Execute the actions being tested) ==
        // Owner 1 confirms the newly created transaction (Index 0)
        vm.prank(owner1);
        multisignature.confirmTransaction(0);

        // Owner 2 also confirms the same transaction (Index 0)
        vm.prank(owner2);
        multisignature.confirmTransaction(0);

                // == ASSERT(Verify the expected state and outcomes) ==

        // Fetch the transaction details from the contract
        (
            ,
            ,
            ,
            uint256 numConfirmations,
            MultiSignature.TxState state
        ) = multisignature.getTransaction(0);

        // Check that the transaction has exactly 2 confirmations
        assertEq(numConfirmations, 2);

        // Check that the transaction has exactly 2 confirmations
        assertEq(
            uint256(state),
            uint256(MultiSignature.TxState.Approved)
        );
    }


    /// @notice Ensures that the same owner cannot confirm the same multisignature transaction twice.
    function testCannotConfirmTwice() public {
                // == ARRANGE ==

        // Submit a new transaction so that there is a valid pending transaction (ID: 0) to interact with.
        vm.prank(owner1);
        multisignature.submitTransaction(user, 1 ether, "");

                // == ACT ==
        // Have owner1 confirm the transaction for the first time. This action is expected to succeed.
        vm.prank(owner1);
        multisignature.confirmTransaction(0);


                // == ACT == ASSERT
        // Set the expected next call to revert because owner1 is trying to confirm the exact same transaction ID (0) a second time.
        vm.prank(owner1);

        vm.expectRevert();

        multisignature.confirmTransaction(0);
    }




    /*//////////////////////////////////////////////////////////////
                              EXECUTE FUNCTION
    //////////////////////////////////////////////////////////////*/

    /// @notice Multi-Signature Wallet Transaction Execution Test
     function testExecuteTransaction() public {

                // == ARRANGE ==
        // Give the Multisig contract enough funds to send 2 ether
        vm.deal(address(multisignature), 2 ether);

        // Capture the initial balance of the recipient to verify it later
        uint256 userBalanceBefore = user.balance;

         // Owner 1 submits a new transaction to send 1 ether to the user address
        vm.prank(owner1);
        multisignature.submitTransaction(user, 1 ether, "");

        // Owners 1  confirm the pending transaction (ID: 0) to meet signature requirements
        vm.prank(owner1);
        multisignature.confirmTransaction(0);

        // Owners 2 confirm the pending transaction (ID: 0) to meet signature requirements
        vm.prank(owner2);
        multisignature.confirmTransaction(0);

                // == ACT ==
        // Owner 1 executes the fully confirmed transaction
        vm.prank(owner1);
        multisignature.executeTransaction(0);

                  // == ASSERT ==
         // Fetch the updated balance of the recipient and the transaction state
        uint256 userBalanceAfter = user.balance;

        (
            ,
            ,
            ,
            ,
            MultiSignature.TxState state
        ) = multisignature.getTransaction(0);

        // Verify the user received the 1 ether
        assertEq(userBalanceAfter, userBalanceBefore + 1 ether);

         // Verify the transaction state has updated to 'Executed'
        assertEq(
            uint256(state),
            uint256(MultiSignature.TxState.Executed)
        );
    }


    /// @notice Test that a transaction cannot be executed if it has not reached the required number of confirmations.
    function testCannotExecuteWithoutEnoughConfirmations() public {
                // == ARRANGE ==
        
        // Submit a new transaction proposal for 1 ether to be sent to the user.
        vm.prank(owner1);
        multisignature.submitTransaction(user, 1 ether, "");

        // Confirm the transaction using owner1 (leaving it at only 1 confirmation).
        vm.prank(owner1);
        multisignature.confirmTransaction(0);

                // == ACT ==
        // Set up the expectation that the next call will revert.
        vm.prank(owner1);

        vm.expectRevert();

                // == ASSERT ==
        // Attempt to execute the transaction before the required confirmations are met.
        multisignature.executeTransaction(0);
    }


     function testCannotExecuteIfInsufficientBalance() public {
                // == ARRANGE ==
        // Submit a transaction that requires 50 ether, exceeding the contract's balance
        vm.prank(owner1);

        multisignature.submitTransaction(
            user,
            50 ether,
            ""
        );

        // Owners 1 confirm the submitted transaction to reach consensus
        vm.prank(owner1);
        multisignature.confirmTransaction(0);

        // Owners 2 confirm the submitted transaction to reach consensus
        vm.prank(owner2);
        multisignature.confirmTransaction(0);

                // == ACT ==
        // Attempt to execute the transaction, expecting it to revert due to insufficient funds
        vm.prank(owner1);

                // == ASSERT ==
        // Enforce that the execution fails (reverts)
        vm.expectRevert();

        multisignature.executeTransaction(0);
    }




     /*//////////////////////////////////////////////////////////////
                               REVOKE FUNCTION
    //////////////////////////////////////////////////////////////*/
    function testRevokeConfirmation() public {
                // == ARRANGE ==
        // Owner 1 submits a new transaction of 1 ether to the user address
        vm.prank(owner1);
        multisignature.submitTransaction(user, 1 ether, "");
        
        // Owner 1 confirms the newly submitted transaction (ID: 0)
        vm.prank(owner1);
        multisignature.confirmTransaction(0);

                // == ACT ==
        // Owner 1 revokes their prior confirmation for transaction 0
        vm.prank(owner1);
        multisignature.revokeConfirmation(0);

                // == ASSERT ==
         // Fetch the updated transaction details from the smart contract
        (
            ,
            ,
            ,
            uint256 numConfirmations,
            MultiSignature.TxState state
        ) = multisignature.getTransaction(0);

        // Verify that the number of confirmations has decreased to 0
        assertEq(numConfirmations, 0);

        // Verify that the transaction state has updated to Revoked
        assertEq(
            uint256(state),
            uint256(MultiSignature.TxState.Revoked)
        );
    }


     /// @notice Tests that revoking a confirmation without first confirming the transaction reverts
      function testCannotRevokeWithoutConfirming() public {
                // ARRANGE
        // Set the submitter to `owner1` and submit a new transaction
        vm.prank(owner1);
        multisignature.submitTransaction(user, 1 ether, "");

                // ACT / ASSERT
        // Set the caller to `owner2`, anticipate a revert, and attempt to revoke confirmation 0
        vm.prank(owner2);

        vm.expectRevert();

        multisignature.revokeConfirmation(0);
    }




        /*//////////////////////////////////////////////////////////////
                            GETTERS FUNCTION
        //////////////////////////////////////////////////////////////*/
    function testGetOwners() public {
            // ARRANGE
        // Set up the necessary state and data for the test.

            // ACT
        // Execute the specific function being tested.
        address[] memory owners = multisignature.getOwners();

            // ASSERT
        // Verify the outcome is exactly what was expected.
        assertEq(owners.length, 3);

        // Verify that the retrieved addresses match the initialized owners in order.
        assertEq(owners[0], owner1);
        assertEq(owners[1], owner2);
        assertEq(owners[2], owner3);
    }


    /// @notice Verifies that transaction count increments correctly upon multiple submissions
    function testGetTransactionCount() public {
                // ARRANGE
        // Verify initial transaction count is 0 and start impersonating owner1
        assertEq(multisignature.getTransactionCount(), 0);

        vm.startPrank(owner1);

                // ACT
        // Submit two new transactions to the multisignature wallet
        multisignature.submitTransaction(user, 1 ether, "");
        multisignature.submitTransaction(user, 2 ether, "");

                // ASSERT
        // Stop impersonating and verify the transaction count has increased to 2
        vm.stopPrank();

        assertEq(multisignature.getTransactionCount(), 2);
    }




    /*//////////////////////////////////////////////////////////////
                           ONLY OWNER FUNCTION
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Verifies that a non-owner cannot submit a transaction and triggers a revert
     function testNonOwnerCannotSubmit() public {
                // ARRANGE
        // Set up the environment by spoofing a non-owner address
        vm.prank(user);

                // ACT
        // Attempt to execute the transaction from the spoofed non-owner address
        vm.expectRevert();

                // ARRANGE
        // Validate that the transaction reverts (intercepted by vm.expectRevert)
        multisignature.submitTransaction(user, 1 ether, "");
    }

    
    /// @notice Tests that a non-owner cannot confirm a transaction
    function testNonOwnerCannotConfirm() public {
                // ARRANGE
        // Impersonate the contract owner to submit a valid transaction first
        vm.prank(owner1);
        multisignature.submitTransaction(user, 1 ether, "");

                // ACT
        // Change the msg.sender to the user (who is NOT an owner)
        vm.prank(user);

        // Expect the next transaction call to revert 
        vm.expectRevert();

                // ASSERT 
         // Call confirmTransaction as a non-owner; this will revert as expected
        multisignature.confirmTransaction(0);
    }


    function testNonOwnerCannotExecute() public {
                // ARRANGE
        // Owner 1 submits a new transaction sending 1 ether to the user
        vm.prank(owner1);
        multisignature.submitTransaction(user, 1 ether, "");

         // Owner 1 confirm the submitted transaction to reach required approval
        vm.prank(owner1);
        multisignature.confirmTransaction(0);

        //  Owner 2 confirm the submitted transaction to reach required approval
        vm.prank(owner2);
        multisignature.confirmTransaction(0);

                // ACT
        // A non-owner (the 'user') attempts to execute the fully confirmed transaction
        vm.prank(user);

                // ASSERT
        // We expect the transaction execution to revert because the caller is not an owner
        vm.expectRevert();

        multisignature.executeTransaction(0);
    }


    /// @notice Tests that a non-owner cannot revoke an existing transaction confirmation
    function testNonOwnerCannotRevoke() public {
                // ARRANGE 

        // Set up the initial state so a transaction exists and has a confirmation.
        //  Owner1 submits a new transaction.
        vm.prank(owner1);
        multisignature.submitTransaction(user, 1 ether, "");

        //  Owner1 confirms the transaction so it has a confirmation to revoke.
        vm.prank(owner1);
        multisignature.confirmTransaction(0);

                // ACT
        // Execute the action that is expected to fail. 
        // We prank as a non-owner (user) attempting to revoke the confirmation.
        vm.prank(user);

                // ASSERT
        // Define the expected behavior. 
        // We instruct Foundry to expect the very next transaction to revert.
        vm.expectRevert();

        // Attempt the revocation, triggering the assertion.
        multisignature.revokeConfirmation(0);
    }

}