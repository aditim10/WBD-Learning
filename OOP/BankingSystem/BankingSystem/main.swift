import Foundation

print("========== Banking System ==========\n")

let bank = Bank(bankName: "National Bank")

do {

    // MARK: Create Accounts

    let aditiSavingsAccount = SavingsAccount(
        accountHolderName: "Aditi",
        accountNumber: "SAV-001",
        initialBalance: 50000,
        interestRate: 5.5
    )

    let ayanCurrentAccount = CurrentAccount(
        accountHolderName: "Ayan",
        accountNumber: "CUR-001",
        initialBalance: 20000,
        overdraftLimit: 15000
    )

    let prabhaSavingsAccount = SavingsAccount(
        accountHolderName: "Prabha"
    )

    // MARK: Open Accounts

    try bank.openAccount(aditiSavingsAccount)

    try bank.openAccount(ayanCurrentAccount)

    try bank.openAccount(prabhaSavingsAccount)

    // MARK: Deposits

    try aditiSavingsAccount.deposit(
        amount: 10000,
        note: "Salary Credit"
    )

    try ayanCurrentAccount.deposit(
        amount: 5000,
        note: "Cash Deposit"
    )

    // MARK: Withdrawals

    try aditiSavingsAccount.withdraw(
        amount: 5000,
        note: "Online Shopping"
    )

    try ayanCurrentAccount.withdraw(
        amount: 30000,
        note: "Business Payment"
    )

    // MARK: Interest

    try aditiSavingsAccount.applyMonthlyInterest()

    // MARK: Fund Transfer

    try bank.transferFunds(
        from: "SAV-001",
        to: "CUR-001",
        amount: 5000
    )

    // MARK: Account Summaries

    aditiSavingsAccount.displayAccountSummary()

    ayanCurrentAccount.displayAccountSummary()

    // MARK: Transaction History

    aditiSavingsAccount.displayTransactionHistory()

    ayanCurrentAccount.displayTransactionHistory()

    // MARK: All Accounts

    bank.displayAllAccounts()

} catch BankError.invalidAmount {

    print("Invalid amount entered.")

} catch BankError.insufficientFunds {

    print("Insufficient funds available.")

} catch BankError.accountNotFound {

    print("Account not found.")

} catch BankError.duplicateAccount {

    print("Account already exists.")

} catch BankError.overdraftLimitExceeded {

    print("Overdraft limit exceeded.")

} catch {

    print("Unexpected error occurred.")
}
