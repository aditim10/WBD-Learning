import Foundation

extension BankAccount {

    /// Returns short account summary
    var miniStatement: String {

        return "\(accountNumber) | \(accountHolderName) | Rs\(balance)"
    }
}
