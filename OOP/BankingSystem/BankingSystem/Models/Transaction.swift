import Foundation

/// Represents a single transaction performed on an account
struct Transaction {

    // MARK: Properties

    let type: TransactionType

    let amount: Double

    let date: Date

    let note: String

    // MARK: Computed Properties

    /// Returns formatted transaction date
    var formattedDate: String {
        DateFormatterHelper.transactionDateFormatter.string(from: date)
    }

    // MARK: - Methods

    /// Prints transaction details
    func printTransaction() {

        let transactionLabel: String

        switch type {

        case .deposit:
            transactionLabel = "DEPOSIT"

        case .withdrawal:
            transactionLabel = "WITHDRAWAL"

        case .transfer:
            transactionLabel = "TRANSFER"
        }

        print("[\(formattedDate)] \(transactionLabel) | Rs\(amount) | \(note)")
    }
}
