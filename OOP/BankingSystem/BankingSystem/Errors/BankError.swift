import Foundation

/// Represents banking related errors
enum BankError: Error {

    case invalidAmount

    case insufficientFunds

    case accountNotFound

    case duplicateAccount

    case overdraftLimitExceeded

    case invalidRecord
}
