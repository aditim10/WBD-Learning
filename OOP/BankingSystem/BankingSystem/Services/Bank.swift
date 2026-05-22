import Foundation

/// Handles bank level operations
final class Bank {

    // MARK: Properties

    let bankName: String

    private var accounts: [BankAccount] = []

    // MARK: Initializer

    init(bankName: String) {

        self.bankName = bankName
    }

    // MARK: Account Operations

    /// Opens a new bank account
    /// - Parameter account:
    ///   Account object to add
    /// - Throws:
    ///   BankError.duplicateAccount
    func openAccount(_ account: BankAccount) throws {

        let existingAccount = findAccount(
            accountNumber: account.accountNumber
        )

        guard existingAccount == nil else {
            throw BankError.duplicateAccount
        }

        accounts.append(account)
    }

    /// Finds account using account number.
    /// - Parameter accountNumber:
    ///   Account number to search.
    /// - Returns:
    ///   Matching account object.
    func findAccount(accountNumber: String) -> BankAccount? {

        return accounts.first {
            $0.accountNumber == accountNumber
        }
    }

    // MARK: Fund Transfer

    /// Transfers amount between accounts
    /// - Parameters:
    ///   - sourceAccountNumber: Sender account number
    ///   - destinationAccountNumber: Receiver account number
    ///   - amount: Amount to transfer
    /// - Throws:
    ///   BankError.accountNotFound
    func transferFunds(
        from sourceAccountNumber: String,
        to destinationAccountNumber: String,
        amount: Double
    ) throws {

        guard amount > 0 else {
            throw BankError.invalidAmount
        }

        guard
            let sourceAccount = findAccount(
                accountNumber: sourceAccountNumber
            )
        else {
            throw BankError.accountNotFound
        }

        guard
            let destinationAccount = findAccount(
                accountNumber: destinationAccountNumber
            )
        else {
            throw BankError.accountNotFound
        }

        try sourceAccount.withdraw(
            amount: amount,
            note: "Transfer to \(destinationAccountNumber)"
        )

        try destinationAccount.deposit(
            amount: amount,
            note: "Transfer from \(sourceAccountNumber)"
        )
    }

    // MARK: Reports

    /// Displays all bank accounts.
    func displayAllAccounts() {

        print("\n----- All Bank Accounts -----")

        if accounts.isEmpty {

            print("No accounts available.")

        } else {

            accounts.forEach { account in
                print(account.miniStatement)
            }
        }
    }
}
