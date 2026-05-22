import Foundation

/// Any type that can have a discount applied and removed
/// Keeps Cart open for extension — new discount strategies
///         (flat, coupon, seasonal) just need to conform to this protocol
protocol Discountable {

    /// Applies a percentage discount to the total
    /// Parameter percentage: A value between 0 and 100
    func applyDiscount(percentage: Double)

    /// Removes any active discount
    func removeDiscount()

    /// The currently active discount percentage
    var discountPercentage: Double { get }
}