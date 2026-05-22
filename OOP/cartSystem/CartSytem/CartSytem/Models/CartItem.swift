import Foundation

/// Represents a single item stored inside the cart
struct CartItem {

    // MARK: Properties

    let product: Product

    var quantity: Int

    var itemDiscountPercentage: Double

    // MARK: Computed Properties

    /// Total price before discount
    var lineSubtotal: Double {

        product.price * Double(quantity)
    }

    /// Discount amount for this line item
    var lineDiscountAmount: Double {

        lineSubtotal * itemDiscountPercentage / 100
    }

    /// Final line total after item discount
    var finalLineTotal: Double {

        lineSubtotal - lineDiscountAmount
    }
}
