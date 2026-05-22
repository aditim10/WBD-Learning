import Foundation

/// Defines common banking operations
protocol Transactable {

    /// Deposits amount into account
    /// - Parameters:
    ///   - amount: Amount to deposit
    ///   - note: Description of transaction
    /// - Throws:
    ///   BankError.invalidAmount
    func deposit(amount: Double, note: String) throws

    /// Withdraws amount from account
    /// - Parameters:
    ///   - amount: Amount to withdraw
    ///   - note: Description of transaction
    /// - Throws:
    ///   BankError.invalidAmount
    ///   BankError.insufficientFunds
    func withdraw(amount: Double, note: String) throws

    /// Returns current account balance
    /// - Returns:
    ///   Current balance.
    func fetchBalance() -> Double

    /// Displays account transaction history
    func displayTransactionHistory()

    /// Displays account summary
    func displayAccountSummary()
}
