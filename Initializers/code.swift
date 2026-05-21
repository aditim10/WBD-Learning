import Foundation

// Parent Class

class BankAccount {

    var accountHolder: String
    var accountNumber: String

    // Designated Initializer - Every stored property must be set here before anything else
    init(accountHolder: String, accountNumber: String) {

        // 1 - set own properties
        self.accountHolder = accountHolder
        self.accountNumber = accountNumber

        // 2 - self is safe to use now
        print("BankAccount created for \(accountHolder)")
    }

    // Required Initializer - Subclasses are forced to implement this
    required init?(from record: [String: String]) {
        guard
            let holder = record["holder"],
            let number = record["number"]
        else { return nil }     // failable — returns nil if keys are missing

        // 1
        self.accountHolder = holder
        self.accountNumber = number

        // 2
        print("BankAccount restored from record")
    }

    func printSummary() {
        print("[\(accountNumber)] Holder: \(accountHolder)")
    }
}


// Child Class

class SavingsAccount: BankAccount {

    var balance: Double
    var interestRate: Double

    // Designated Initializer
    init(accountHolder: String, accountNumber: String, balance: Double, interestRate: Double) {

        // 1 — child's own properties first
        // Reason: if super.init ran first and called an overridden method, balance/interestRate would still be uninitialized — unsafe memory read
        self.balance      = balance
        self.interestRate = interestRate

        // hand off to parent — this completes Phase 1 for the hierarchy
        super.init(accountHolder: accountHolder, accountNumber: accountNumber)

        // 2 — entire hierarchy is initialized, self is fully safe
        print("SavingsAccount ready — Rs\(balance) at \(interestRate)%")
        printWelcome()
    }

    // Convenience Initializer - Must call self.init first — cannot touch properties before that
    // Only takes accountHolder — accountNumber defaults to "ACC-0000"
    convenience init(accountHolder: String) {
        self.init(
            accountHolder: accountHolder,
            accountNumber: "ACC-0000",
            balance: 0.0,
            interestRate: 3.5
        )
        print("Zero-balance account opened for \(accountHolder)")
    }

    // Required Initializer (forced by parent)
    required init?(from record: [String: String]) {
        guard
            let balanceStr = record["balance"], let balance = Double(balanceStr),
            let rateStr    = record["rate"],    let rate    = Double(rateStr)
        else { return nil }

        // 1 — own props before super
        self.balance      = balance
        self.interestRate = rate
        super.init(from: record)

        // 2
        print("SavingsAccount restored — Rs\(balance)")
    }

    private func printWelcome() {
        // accountHolder is an inherited property — reading it is only safe because phase 1 is already done
        print("Welcome, \(accountHolder)!")
    }

    func deposit(amount: Double) {
        balance += amount
        print("Deposited Rs\(amount). Balance: Rs\(balance)")
    }

    func withdraw(amount: Double) {
        guard amount <= balance else { print("Insufficient funds."); return }
        balance -= amount
        print("Withdrew Rs\(amount). Balance: Rs\(balance)")
    }

    override func printSummary() {
        super.printSummary()
        print("Balance: Rs\(balance) | Rate: \(interestRate)%")
    }
}

// Running

print("--- 1. Designated init ---")
let aditi = SavingsAccount(
    accountHolder: "Aditi",
    accountNumber: "ACC-001",
    balance: 50_000,
    interestRate: 5.5
)
aditi.deposit(amount: 10_000)
aditi.withdraw(amount: 5_000)
aditi.printSummary()

print("\n--- 2. Convenience init ---")
let rahul = SavingsAccount(accountHolder: "Rahul")
rahul.deposit(amount: 20_000)
rahul.printSummary()

print("\n--- 3. Required & Failable init ---")
let record: [String: String] = [
    "holder": "Meena", "number": "ACC-003", "balance": "15000", "rate": "4.0"
]
if let meena = SavingsAccount(from: record) {
    meena.printSummary()
}

// Missing balance key — returns nil safely
let badRecord: [String: String] = ["holder": "Ghost", "number": "ACC-000"]
if SavingsAccount(from: badRecord) == nil {
    print("Could not restore — record incomplete")
}