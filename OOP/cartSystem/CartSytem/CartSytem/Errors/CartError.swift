import Foundation

/// Represents cart related errors
enum CartError: Error {

    case invalidQuantity

    case invalidDiscount

    case productNotFound

    case cartEmpty
}
