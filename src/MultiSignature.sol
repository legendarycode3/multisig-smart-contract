// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

/**
 * @title   Multi-Signature Wallet
 * @author  LegendaryCode
 * @notice  A secure, decentralized smart contract wallet that requires multiple independent approvals to execute transactions. Designed to eliminate single points of failure and protect high-value assets.
 */


contract MultiSignature {


    /*///////////////////////////////////////////////////////////////
                                TYPE DECLARATIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice State of the transactions
    enum TxState {
        Pending,  // Transaction proposed, awaiting confirmations
        Approved, // Transaction met required confirmations
        Executed,  // Transaction funds were transferred successfully
        Revoked  // Transaction approval was pulled back by the submitter
    }

    /// @notice Structure representing a single transaction proposal
    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        uint256 numConfirmations;
        TxState state;
    }



    /*///////////////////////////////////////////////////////////////
                                STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    /// @notice List of authorized owners
    address[] public s_owners;

    /// @notice Mapping that checks if an address is a valid owner.
    mapping (address => bool) public s_isOwner;

    /// @notice Number of approvals required to execute a transaction.
    uint256 public s_numConfirmationsRequired;

    /// @notice Array of all proposed transactions.
    Transaction[] public s_transactions;

    /// @notice Mapping to track which owner has comfirmed which transaction
    mapping (uint256 => mapping(address => bool)) public s_isConfirmed;


    
    /*///////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    /// @dev Events to track state changes and activities on the blockchain
    event Deposit(address indexed sender, uint256 amount, uint256 balance);
    event SubmitTransaction(address indexed owner, uint256 indexed txIndex, address indexed to, uint256 value, bytes data); 
    event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint256 indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);



    /*///////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    error Not__Owner();
    error Transaction__NotExisting(uint256 txIndex);
    error Tx__AlreadyExecuted(uint256 txIndex );
    error Tx__AlreadyRevoked(uint256 txIndex);
    error  Owners__Required();
    error Invalid__ConfirmationCount(uint256 numRequired, uint256 totalOwners);
    error Invalid__Owner(address providedAddress);
    error Owner__NotUnique(address duplicateOwner);
    error Tx__AlreadyConfirmed(uint256 txIndex, address comfirmer);
    error Transaction__NotApproved();
    error Transaction__AlreadyExecuted();
    error Cannot__ExecuteTransaction(uint256 currentConfirmations, uint256 requiredConfirmations);
    error Insufficient__ContractBalance(uint256 contractBalance, uint256 requiredValue);
    error Transaction__Failed();
    error Tx__NotConfirmed(uint256 txIndex, address confirmer);




    /*///////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/
    /// @dev Modifier to restrict functions only to authorized owners.
    modifier onlyOwner() {
        if(!s_isOwner[msg.sender]) {
            revert Not__Owner();
        }
        _;
    }

    /// @dev Modifier to ensure transaction exist
    modifier txExist(uint256 _txIndex) {
        if (_txIndex >= s_transactions.length) {
            revert Transaction__NotExisting(_txIndex);
        }
        _;
    }

    /// @dev Modifier to ensure the transaction is not yet executed.
    modifier notExecuted(uint256 _txIndex) {
        if (s_transactions[_txIndex].state ==  TxState.Executed) {
            revert Tx__AlreadyExecuted(_txIndex);
        }
        _;
        // if (transactions[_txIndex].executed) {
        //     revert Tx__AlreadyExecuted(_txIndex);
        // }
        // _;
    }

    /// @dev Modifier to ensure the transaction has not been revoked
     modifier notRevoked(uint256 _txIndex) {
        if (s_transactions[_txIndex].state ==  TxState.Revoked) {
            revert Tx__AlreadyRevoked(_txIndex);
        }
        _;
    }



    /*///////////////////////////////////////////////////////////////
                                CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    /**
     * @dev Initializes the contract, by setting up authorized owners and required comfirmation threshold.
     * @param _owners array of initial owner addresses.
     * @param _numConfirmationsRequired Number of signatures required to execute a transaction
     */
    constructor(address[] memory _owners, uint256 _numConfirmationsRequired ) {
        // Validate that the owners array is not empty
        if (_owners.length == 0) {
            revert  Owners__Required();
        }

         // Ensure required confirmations are at least 1 and do not exceed the total number of owners
        if (_numConfirmationsRequired == 0 || _numConfirmationsRequired > _owners.length) {
            revert Invalid__ConfirmationCount(_numConfirmationsRequired, _owners.length);
        }

        
        /** 
         * @notice Iterates through the provided addresses to register them as owners.
         * The loop ensures data integrity by checking for valid addresses and preventing duplicates. (Iterates through an existing list of address)
        */
        for(uint256 i = 0; i < _owners.length; i++) {

            /** Retrieve the owner's address at the current index 
             * 
             * At every step of the loop, this line grabs the address located at the current position (i) in the _owners array and temporarily stores it in a new variable named "owner"
             */
            address owner = _owners[i];

            //Ensure the address provided isn't the 'zero address' (0x0...). Just reverts if the provided owner address is the 'zero address' (null/uninitialized)
            if (owner == address(0)) {
                revert Invalid__Owner(owner);
            }

            // Check the mapping to ensure this address isn't already added (prevents duplicates)
            if(s_isOwner[owner]){
                revert Owner__NotUnique(owner);
            }

            // Register owner in the mapping for constant-time lookup
            s_isOwner[owner] = true;

            // Add the owner address to the state array to keep a record of all owners (for enumeration)
            s_owners.push(owner);
        }

        // Set the security threshold for transaction execution
        s_numConfirmationsRequired = _numConfirmationsRequired;
    }



    /*///////////////////////////////////////////////////////////////
                                FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Fallback function to allow the contract to receive Ether
     * 
     * @dev External fallback function triggered when the contract receives Ether 
     * without any accompanying data (e.g., via a simple wallet transfer).
     * 
     * Requirements:
     * - Must be marked 'external' to be accessible by outside callers.
     * - Must be 'payable' to allow the contract to accept and store Ether.
    */
    receive() external payable {
        // Emits a log entry to the blockchain, allowing off-chain applications to track who sent the Ether and how much was sent
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }


    /**
     * @notice Submits a new transaction proposal.
     * @dev Allows an owner to submit a new transaction propsal.
     * @param _to Destination address of the transaction.
     * @param _value Wei value to send.
     * @param _data Additional data payload (Data payload to send with the transaction).
    */
    function submitTransaction(address _to, uint256 _value, bytes memory _data) public onlyOwner {
        
        // Determines the exact index the new transaction will have in the array.
        uint256 txIndex = s_transactions.length;

        // Append the newly created transaction to the transactions array
        s_transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                numConfirmations: 0, // Fresh transaction starts with zero approvals
                state: TxState.Pending  // Initial state is set to Pending
            })
        );

        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
        
    }


    /**
     * @dev Allows an owner to confirm pending transaction.
     * @param _txIndex The index of the transaction in the transactions array (Simply the index of the transaction to confirm)
     */
    function confirmTransaction(uint256 _txIndex) public onlyOwner txExist(_txIndex) notExecuted(_txIndex) notRevoked(_txIndex) {

            /**
             * Retrieve the Transaction struct (modifications will directly update the blockchain state)
             * 
             * This retrieves the Transaction struct from the s_transactions mapping by its txIndex. Using storage ensures that any modifications to the transaction variable directly update the actual transaction data stored on the blockchain, rather than a local copy.
            */
            Transaction storage transaction = s_transactions[_txIndex];

            // Prevent the same owner from confirming the same transaction multiple times
            if (s_isConfirmed[_txIndex][msg.sender] ) {
                revert Tx__AlreadyConfirmed(_txIndex, msg.sender);
            }

            // Mark the transaction as confirmed by this specific owner
            s_isConfirmed[_txIndex][msg.sender] = true;

            // Increment the total confirmation count for this transaction
            transaction.numConfirmations += 1;

            // Update state to Approved if threshold is met( Update state to 'Approved' if the required number of confirmations is reached).
            if (transaction.numConfirmations >= s_numConfirmationsRequired) {
                transaction.state = TxState.Approved;
            }

            // Emit an event to notify off-chain applications that a confirmation occurred
            emit ConfirmTransaction(msg.sender, _txIndex); 
    }



    /**
     * @notice Executes an approved transaction.
     * @param _txIndex The index of the transaction to execute.
     */
    function executeTransaction(uint256 _txIndex) public onlyOwner txExist(_txIndex) notExecuted(_txIndex) {

        // Retrieve the transaction from storage to modify its state
        Transaction storage transaction = s_transactions[_txIndex];

         // Check if it reached the required quorum (Ensure the transaction has gathered the required number of confirmations)
        if (transaction.numConfirmations < s_numConfirmationsRequired) {
            revert Cannot__ExecuteTransaction(transaction.numConfirmations, s_numConfirmationsRequired);
        }

        // Check contract balance (Ensure the contract has enough balance to cover the transaction value)
        if (address(this).balance < transaction.value) {
            revert Insufficient__ContractBalance(address(this).balance, transaction.value);
        }

                // EFFECT - UPDATE STATE FIRST (Checks-Effects-Interactions pattern)
        // Mark the transaction as executed before initiating the external call
        transaction.state = TxState.Executed;

                // INTERACT 
        // Transfer the funds to the intended destination using the low-level call
        (bool success, ) = transaction.to.call{ value: transaction.value }(transaction.data);

            
        if (!success) {
            revert Transaction__Failed();
        }
        
         // Emit the event confirming successful execution
        emit ExecuteTransaction(msg.sender, _txIndex);
    }


    /**
     * @notice  Revokes a previously submitted confirmation for a transaction.
     * @param _txIndex The index of the transaction to revoke.
     * 
     * onlyOwner(): Restricts access to registered wallet owners only
     * txExist(): Ensures the transaction index exists
     * notExecute(): Prevents revoking confirmations on executed transactions
    */
    function revokeConfirmation(uint _txIndex) public onlyOwner txExist(_txIndex) notExecuted(_txIndex) {
        
        // Retrieve the transaction from storage to modify its state (Using 'storage' avoids unnecessary memory copying and allows direct modification). Load the transaction from storage.
        Transaction storage transaction = s_transactions[_txIndex];

        // Verify that the caller has previously confirmed this transaction. (Prevents double revocation or revoking without prior approval).
        if (!s_isConfirmed[_txIndex][msg.sender]) {
            revert Tx__NotConfirmed(_txIndex, msg.sender);
        }

        // Remove the caller's confirmation status(This updates the owner-to-transaction confirmation mapping).
        s_isConfirmed[_txIndex][msg.sender] = false;

        transaction.state = TxState.Revoked;

        // Decrease the total number of confirmations for the transaction.
        transaction.numConfirmations -= 1;

        // If the transaction was previously marked as Approved, but the confirmation count now falls below the required threshold, revert its state back to Pending.
        // This preserves consistency between: confirmation count & transaction state
        if (transaction.numConfirmations < s_numConfirmationsRequired && transaction.state == TxState.Approved) {
            transaction.state = TxState.Pending;
        }

        // Emit an event for off-chain tracking and frontend updates.
        emit RevokeConfirmation(msg.sender, _txIndex);
    } 



    
    /*///////////////////////////////////////////////////////////////
                            VIEW/HELPER  FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Gets the total number of submitted transactions.
    function getTransactionCount() public view returns (uint256) {
        return s_transactions.length;
    }


    /**
     * @notice Retrieves detailed information about a specific transaction.
     * @param _txIndex The index of the transaction to fetch.
     */ 
    /**
     * @dev Retrieves the details of a specific transaction stored in the contract.
     * @param _txIndex The index of the transaction in the `s_transactions` array.
     * @return to The destination address for the transaction.
     * @return value The amount of Wei (or native token) to be sent.
     * @return data The arbitrary transaction payload/data (e.g., function calls).
     * @return numConfirmations The current number of approvals this transaction has received.
     * @return state The current status of the transaction (e.g., Pending, Executed).
     */
    function getTransaction(uint256 _txIndex) public view 
    returns(
        address to, 
        uint256 value, 
        bytes memory data,
        uint256 numConfirmations, 
        TxState state
    ) {
         
        // Use the `storage` data location to create a reference to the specific transaction,in state memory(preventing a costly and unnecessary copy of the struct).
        Transaction storage transaction = s_transactions[_txIndex];

        // Return the destructured variables exactly as defined in the returns signature.
        return (
            transaction.to, 
            transaction.value, 
            transaction.data,
            transaction.numConfirmations, 
            transaction.state
        );
    } 


    function getOwners() public view returns(address[] memory) {
         return s_owners;
    }
     

}



















