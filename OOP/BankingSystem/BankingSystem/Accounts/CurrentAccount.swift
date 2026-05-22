import Foundation

/// Represents current account type
final class CurrentAccount: BankAccount {

    // MARK: Properties

    let overdraftLimit: Double

    // MARK: Initializers

    init(
        accountHolderName: String,
        accountNumber: String,
        initialBalance: Double = 0.0,
        overdraftLimit: Double = 10000
    ) {

        self.overdraftLimit = overdraftLimit

        super.init(
            accountHolderName: accountHolderName,
            accountNumber: accountNumber,
            initialBalance: initialBalance
        )
    }

    required init?(record: [String: String]) {

        guard
            let overdraftString = record["overdraftLimit"],
            let overdraftLimit = Double(overdraftString)
        else {
            return nil
        }

        self.overdraftLimit = overdraftLimit

        super.init(record: record)
    }

    // MARK: Methods

    override func withdraw(
        amount: Double,
        note: String = "Withdrawal"
    ) throws {

        guard amount > 0 else {
            throw BankError.invalidAmount
        }

        let availableBalance = balance + overdraftLimit

        guard amount <= availableBalance else {
            throw BankError.overdraftLimitExceeded
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

    override func displayAccountSummary() {

        super.displayAccountSummary()

        print("Overdraft     : Rs\(overdraftLimit)")

        print("Account Type  : Current")
    }
}
