import Foundation


//Transaction (Struct)

struct Transaction {

    // Enum nested inside transaction — keeps related types together
    enum TransactionType {
        case deposit
        case withdrawal
        case transfer
    }

    let type:   TransactionType
    let amount: Double
    let date:   Date
    let note:   String    

    // Computed property — formats date on read, no stored overhead
    var formattedDate: String {
        let fmt        = DateFormatter()
        fmt.dateStyle  = .medium
        fmt.timeStyle  = .short
        return fmt.string(from: date)
    }

    func printRecord() {
        let label: String
        switch type {
        case .deposit:    label = "DEPOSIT    +"
        case .withdrawal: label = "WITHDRAWAL -"
        case .transfer:   label = "TRANSFER   ~"
        }
        print("  \(formattedDate)  \(label)Rs\(amount)  [\(note)]")
    }
}


// Protocol: Transactable

protocol Transactable {
    func deposit(amount: Double, note: String)
    func withdraw(amount: Double, note: String) -> Bool      // returns success/failure
    func checkBalance() -> Double
    func transactionHistory()
    func printSummary()
}


// BankAccount (Base Class)

class BankAccount: Transactable {

    var accountHolder: String
    var accountNumber: String
    private(set) var balance: Double            // readable outside, writable only here
    private var transactions: [Transaction] = []

    // Designated Initializer
    init(accountHolder: String, accountNumber: String, initialBalance: Double = 0.0) {

        // 1 — set own properties first
        self.accountHolder = accountHolder
        self.accountNumber = accountNumber
        self.balance       = initialBalance

        // 2 — self is safe now
        print("Account \(accountNumber) created for \(accountHolder)")
    }

    // Required Initializer 
    required init?(from record: [String: String]) {
        guard
            let holder  = record["holder"],
            let number  = record["number"],
            let balStr  = record["balance"],
            let bal     = Double(balStr)
        else { return nil }

        // 1
        self.accountHolder = holder
        self.accountNumber = number
        self.balance       = bal

        // 2
        print("Account \(number) restored from record")
    }

    fileprivate func record(_ transaction: Transaction) {
        transactions.append(transaction)
    }

    // Transactable conformance
    func deposit(amount: Double, note: String = "Deposit") {
        guard amount > 0 else { print("Deposit amount must be positive."); return }

        balance += amount
        record(Transaction(type: .deposit, amount: amount, date: Date(), note: note))
        print("[\(accountNumber)] Deposited Rs\(amount). New balance: Rs\(balance)")
    }

    // Base withdraw — only allows spending up to the current balance
    @discardableResult
    func withdraw(amount: Double, note: String = "Withdrawal") -> Bool {
        guard amount > 0            else { print("Amount must be positive.");    return false }
        guard amount <= balance     else { print("Insufficient funds.");         return false }

        balance -= amount
        record(Transaction(type: .withdrawal, amount: amount, date: Date(), note: note))
        print("[\(accountNumber)] Withdrew Rs\(amount). New balance: Rs\(balance)")
        return true
    }

    func checkBalance() -> Double {
        print("[\(accountNumber)] Current balance: Rs\(balance)")
        return balance
    }

    func transactionHistory() {
        print("--- Transaction History: \(accountNumber) ---")
        if transactions.isEmpty {
            print("  No transactions yet.")
        } else {
            transactions.forEach { $0.printRecord() }
        }
        print("-------------------------------------------")
    }

    // Will be overridden by subclasses — base version prints shared fields
    func printSummary() {
        print("Account  : \(accountNumber)")
        print("Holder   : \(accountHolder)")
        print("Balance  : Rs\(balance)")
    }
}


// SavingsAccount (Child)

class SavingsAccount: BankAccount {

    var interestRate: Double      // annual rate in %

    // Designated Initializer
    init(accountHolder: String, accountNumber: String,
         initialBalance: Double = 0.0, interestRate: Double = 3.5) {

        // 1 — own properties before super
        self.interestRate = interestRate

        // Completes 1 for the whole hierarchy
        super.init(accountHolder: accountHolder, accountNumber: accountNumber,
                   initialBalance: initialBalance)

        // 2 — hierarchy is fully initialised; self is safe
        print("SavingsAccount ready — Rs\(initialBalance) at \(interestRate)%")
    }

    // Convenience Initializer — zero-balance account with defaults
    convenience init(accountHolder: String) {
        self.init(accountHolder: accountHolder, accountNumber: "SAV-0000")
        print("Zero-balance savings account opened for \(accountHolder)")
    }

    // Required Initializer (forced by BankAccount)
    required init?(from record: [String: String]) {
        guard
            let rateStr = record["interestRate"],
            let rate    = Double(rateStr)
        else { return nil }

        // 1
        self.interestRate = rate
        super.init(from: record)

        // 2
        print("SavingsAccount restored — rate: \(rate)%")
    }

    // Applies monthly simple interest and deposits it as a transaction
    func applyInterest() {
        let monthlyRate   = interestRate / 100.0 / 12.0
        let interestEarned = balance * monthlyRate
        deposit(amount: interestEarned, note: "Interest @ \(interestRate)% p.a.")
        print("[\(accountNumber)] Interest applied: Rs\(String(format: "%.2f", interestEarned))")
    }

    // Extension point — override to add interest-rate line
    override func printSummary() {
        super.printSummary()
        print("Rate     : \(interestRate)%")
        print("Type     : Savings Account")
    }
}


// CurrentAccount (Child)

class CurrentAccount: BankAccount {

    var overdraftLimit: Double    // how far below zero this account can go

    // Designated Initializer
    init(accountHolder: String, accountNumber: String,
         initialBalance: Double = 0.0, overdraftLimit: Double = 10_000.0) {

        // 1
        self.overdraftLimit = overdraftLimit

        super.init(accountHolder: accountHolder, accountNumber: accountNumber,
                   initialBalance: initialBalance)

        // 2
        print("CurrentAccount ready — overdraft limit: Rs\(overdraftLimit)")
    }

    // Required Initializer
    required init?(from record: [String: String]) {
        guard
            let limitStr = record["overdraftLimit"],
            let limit    = Double(limitStr)
        else { return nil }

        // 1
        self.overdraftLimit = limit
        super.init(from: record)

        // 2
        print("CurrentAccount restored — limit: Rs\(limit)")
    }

    // Override withdraw — allows balance to go negative up to overdraftLimit
    @discardableResult
    override func withdraw(amount: Double, note: String = "Withdrawal") -> Bool {
        guard amount > 0 else { print("Amount must be positive."); return false }

        // Available funds = current balance + how much overdraft is still unused
        let available = balance + overdraftLimit
        guard amount <= available else {
            print("[\(accountNumber)] Exceeds overdraft limit. Available: Rs\(available)")
            return false
        }

        // can't call super.withdraw because that checks balance <= amount
        balance -= amount       // 'balance' is accessible (same module)
        record(Transaction(type: .withdrawal, amount: amount, date: Date(), note: note))
        print("[\(accountNumber)] Withdrew Rs\(amount). Balance: Rs\(balance)" +
              (balance < 0 ? " (overdraft)" : ""))
        return true
    }

    override func printSummary() {
        super.printSummary()
        print("Overdraft: Rs\(overdraftLimit)")
        print("Type     : Current Account")
    }
}


// extension on BankAccount
extension BankAccount {
    var miniStatement: String {
        "[\(accountNumber)] \(accountHolder) — Rs\(balance)"
    }
}


//Bank (Manager Class)
class Bank {

    let bankName: String
    private var accounts: [BankAccount] = []

    init(bankName: String) {
        self.bankName = bankName
        print("\(bankName) is now open.")
    }

    //Account Management

    func openAccount(_ account: BankAccount) {
        // against duplicate account numbers
        guard findAccount(accountNumber: account.accountNumber) == nil else {
            print("Account \(account.accountNumber) already exists.")
            return
        }
        accounts.append(account)
        print("[\(bankName)] Opened: \(account.miniStatement)")
    }

    // Returns nil if not found
    func findAccount(accountNumber: String) -> BankAccount? {
        accounts.first { $0.accountNumber == accountNumber }
    }

    // Fund Transfer

    func transferFunds(from sourceNumber: String, to destNumber: String, amount: Double) {
        guard let source = findAccount(accountNumber: sourceNumber) else {
            print("Source account \(sourceNumber) not found."); return
        }
        guard let dest = findAccount(accountNumber: destNumber) else {
            print("Destination account \(destNumber) not found."); return
        }
        guard amount > 0 else { print("Transfer amount must be positive."); return }

        // withdraw returns false if funds are insufficient — abort 
        let note = "Transfer to \(destNumber)"
        guard source.withdraw(amount: amount, note: note) else {
            print("Transfer failed — could not debit source account.")
            return
        }

        dest.deposit(amount: amount, note: "Transfer from \(sourceNumber)")
        print("[\(bankName)] Rs\(amount) transferred: \(sourceNumber) -> \(destNumber)")
    }

    // Reports

    func listAllAccounts() {
        print("\n=== \(bankName) — All Accounts ===")
        if accounts.isEmpty {
            print("  No accounts yet.")
        } else {
            accounts.forEach { print("  \($0.miniStatement)") }
        }
        print("----------------------\n")
    }
}


// main part

print("---------- BANK SYSTEM ----------\n")

let bank = Bank(bankName: "Swift National Bank")

// Designated inits
print("\n--- Opening Accounts ---")
let aditi = SavingsAccount(accountHolder: "Aditi",   accountNumber: "SAV-001",
                           initialBalance: 50_000,   interestRate: 5.5)
let ayan = CurrentAccount(accountHolder: "Ayan",   accountNumber: "CUR-001",
                           initialBalance: 20_000,   overdraftLimit: 15_000)
let prabha = SavingsAccount(accountHolder: "Prabha")   // convenience init

bank.openAccount(aditi)
bank.openAccount(ayan)
bank.openAccount(prabha)

// Deposits and withdrawals
print("\n--- Deposits & Withdrawals ---")
aditi.deposit(amount: 10000)
aditi.withdraw(amount: 5000)

ayan.deposit(amount: 5000)
ayan.withdraw(amount: 30000)          // goes into overdraft — allowed up to Rs15k
ayan.withdraw(amount: 10000)          // should fail — exceeds overdraft limit

prabha.deposit(amount: 8000)

// Interest on savings
print("\n--- Applying Interest ---")
aditi.applyInterest()

// Balance checks
print("\n--- Balance Checks ---")
aditi.checkBalance()
ayan.checkBalance()

// Fund transfer
print("\n--- Fund Transfer ---")
bank.transferFunds(from: "SAV-001", to: "CUR-001", amount: 5_000)

// Summaries
print("\n--- Account Summaries ---")
aditi.printSummary()
print("")
ayan.printSummary()

// Transaction histories
print("\n--- Transaction Histories ---")
aditi.transactionHistory()
ayan.transactionHistory()

// Required & failable init (restore from record)
print("\n--- Restore from Record ---")
let record: [String: String] = [
    "holder": "Ghost", "number": "SAV-999", "balance": "12500", "interestRate": "4.0"
]
if let ghost = SavingsAccount(from: record) {
    bank.openAccount(ghost)
    ghost.printSummary()
}

// Missing key — returns nil safely
let badRecord: [String: String] = ["holder": "Ghost", "number": "SAV-000"]
if SavingsAccount(from: badRecord) == nil {
    print("Could not restore — record incomplete (missing balance/interestRate)")
}

// 9. Full account list
bank.listAllAccounts()