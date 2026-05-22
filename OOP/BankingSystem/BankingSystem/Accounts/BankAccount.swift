import Foundation

/// Base class representing a bank account
class BankAccount: Transactable {

    // MARK: Properties

    let accountHolderName: String

    let accountNumber: String

    internal var balance: Double

    private var transactions: [Transaction] = []

    // MARK: Initializers

    init(
        accountHolderName: String,
        accountNumber: String,
        initialBalance: Double = 0.0
    ) {

        self.accountHolderName = accountHolderName

        self.accountNumber = accountNumber

        self.balance = initialBalance
    }

    required init?(record: [String: String]) {

        guard
            let holderName = record["holder"],
            let accountNumber = record["number"],
            let balanceString = record["balance"],
            let balanceAmount = Double(balanceString)
        else {
            return nil
        }

        self.accountHolderName = holderName

        self.accountNumber = accountNumber

        self.balance = balanceAmount
    }

    // MARK: Public Methods

    /// Deposits amount into account
    /// - Parameters:
    ///   - amount: Amount to deposit
    ///   - note: Transaction note
    /// - Throws:
    ///   BankError.invalidAmount
    func deposit(amount: Double, note: String = "Deposit") throws {

        guard amount > 0 else {
            throw BankError.invalidAmount
        }

        balance += amount

        let transaction = Transaction(
            type: .deposit,
            amount: amount,
            date: Date(),
            note: note
        )

        recordTransaction(transaction)
    }

    /// Withdraws amount from account
    /// - Parameters:
    ///   - amount: Amount to withdraw
    ///   - note: Transaction note
    /// - Throws:
    ///   BankError.invalidAmount
    ///   BankError.insufficientFunds
    func withdraw(amount: Double, note: String = "Withdrawal") throws {

        guard amount > 0 else {
            throw BankError.invalidAmount
        }

        guard amount <= balance else {
            throw BankError.insufficientFunds
        }

        balance -= amount

        let transaction = Transaction(
            type: .withdrawal,
            amount: amount,
            date: Date(),
            note: note
        )

        recordTransaction(transaction)
    }

    /// Returns account balance
    /// - Returns:
    ///   Current account balance
    func fetchBalance() -> Double {
        return balance
    }

    /// Displays transaction history
    func displayTransactionHistory() {

        print("\nTransaction History - \(accountNumber)")

        if transactions.isEmpty {

            print("No transactions available.")

        } else {

            transactions.forEach { transaction in
                transaction.printTransaction()
            }
        }
    }

    /// Displays account summary
    func displayAccountSummary() {

        print("\nAccount Holder : \(accountHolderName)")

        print("Account Number : \(accountNumber)")

        print("Balance        : Rs\(balance)")
    }

    // MARK: Internal Methods

    /// Stores transaction into history
    /// - Parameter transaction:
    ///   Transaction object to store
    internal func recordTransaction(_ transaction: Transaction) {

        transactions.append(transaction)
    }
}
