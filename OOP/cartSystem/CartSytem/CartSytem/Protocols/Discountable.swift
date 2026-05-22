import Foundation

/// Defines discount related operations
protocol Discountable {

    /// Applies cart level discount
    /// - Parameter percentage:
    ///   Discount percentage.
    /// - Throws:
    ///   CartError.invalidDiscount
    func applyCartDiscount(
        percentage: Double
    ) throws

    /// Removes active cart discount
    func removeCartDiscount()

    /// Current cart discount percentage
    var cartDiscountPercentage: Double { get }
}
