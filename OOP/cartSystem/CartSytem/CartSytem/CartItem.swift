import Foundation

/// A single line item in the cart — one product and quantity
struct CartItem {

    /// The product being purchased
    let product: Product

    /// Number of units of this product in the cart
    var quantity: Int

    /// Total price for this line item (price × quantity)
    var lineTotal: Double {
        product.price * Double(quantity)
    }
}