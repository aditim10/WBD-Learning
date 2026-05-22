import Foundation

/// Represents savings account type
final class SavingsAccount: BankAccount {

    // MARK: Properties

    let interestRate: Double

    // MARK: Initializers

    init(
        accountHolderName: String,
        accountNumber: String,
        initialBalance: Double = 0.0,
        interestRate: Double = 3.5
    ) {

        self.interestRate = interestRate

        super.init(
            accountHolderName: accountHolderName,
            accountNumber: accountNumber,
            initialBalance: initialBalance
        )
    }

    convenience init(accountHolderName: String) {

        self.init(
            accountHolderName: accountHolderName,
            accountNumber: "SAV-0000"
        )
    }

    required init?(record: [String: String]) {

        guard
            let interestRateString = record["interestRate"],
            let interestRate = Double(interestRateString)
        else {
            return nil
        }

        self.interestRate = interestRate

        super.init(record: record)
    }

    // MARK: Methods

    /// Applies monthly interest to account
    func applyMonthlyInterest() throws {

        let monthlyInterestRate = interestRate / 100 / 12

        let interestAmount = balance * monthlyInterestRate

        try deposit(
            amount: interestAmount,
            note: "Monthly Interest"
        )
    }

    override func displayAccountSummary() {

        super.displayAccountSummary()

        print("Interest Rate : \(interestRate)%")

        print("Account Type  : Savings")
    }
}
