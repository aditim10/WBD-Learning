import Foundation

/// Manages the shopping cart — adding, removing, and pricing items
/// Conforms to `Discountable` for discount handling
/// Follows Single Responsibility — Cart only manages cart state

class Cart: Discountable {

    // Properties

    /// All line items currently in the cart, keyed by product
    private var cartItems: [Product: CartItem] = [:]

    /// Active discount percentage. Read publicly, written only here
    private(set) var discountPercentage: Double = 0.0

    // Item Management

    /// Adds a product to the cart. If it already exists, increments quantity.
    /// - Parameters:
    ///   - product: The product to add
    ///   - quantity: Number of units to add. Defaults to 1
    func addItem(_ product: Product, quantity: Int = 1) {
        guard quantity > 0 else {
            print("Quantity must be at least 1.")
            return
        }

        if cartItems[product] != nil {
            cartItems[product]!.quantity += quantity
        } else {
            cartItems[product] = CartItem(product: product, quantity: quantity)
        }

        print("Added '\(product.name)' x\(quantity) — Rs\(product.price) each")
    }

    /// Removes one unit of a product. Deletes the line item if quantity reaches zero
    /// - Parameter productId: The id of the product to remove
    func removeItem(productId: Int) {
        guard let product = cartItems.keys.first(where: { $0.id == productId }) else {
            print("Product with id \(productId) not found in cart.")
            return
        }

        if cartItems[product]!.quantity > 1 {
            cartItems[product]!.quantity -= 1
            print("Removed one '\(product.name)'. Remaining qty: \(cartItems[product]!.quantity)")
        } else {
            cartItems.removeValue(forKey: product)
            print("'\(product.name)' removed from cart.")
        }
    }

    /// Removes all units of a product regardless of quantity
    /// - Parameter productId: The id of the product to fully remove
    func removeAllUnits(productId: Int) {
        guard let product = cartItems.keys.first(where: { $0.id == productId }) else {
            print("Product with id \(productId) not found in cart.")
            return
        }
        cartItems.removeValue(forKey: product)
        print("All units of '\(product.name)' removed from cart.")
    }

    /// Empties the cart completely
    func clearCart() {
        cartItems.removeAll()
        print("Cart cleared.")
    }

    // Pricing

    /// Returns the subtotal before any discount.
    /// - Returns: Sum of all line totals.
    func totalAmount() -> Double {
        cartItems.values.reduce(0) { runningTotal, item in
            runningTotal + item.lineTotal
        }
    }

    /// Returns the final payable amount after applying the active discount
    /// - Returns: Discounted total
    func finalAmount() -> Double {
        let subtotal = totalAmount()
        let discountValue = subtotal * discountPercentage / 100
        return subtotal - discountValue
    }

    // Discountable

    /// Applies a percentage discount to the cart total
    /// - Parameter percentage: Must be between 1 and 100
    func applyDiscount(percentage: Double) {
        guard percentage > 0 && percentage <= 100 else {
            print("Invalid discount. Enter a value between 1 and 100.")
            return
        }
        discountPercentage = percentage
        print("\(percentage)% discount applied.")
    }

    /// Removes the active discount and resets to full price.
    func removeDiscount() {
        discountPercentage = 0
        print("Discount removed.")
    }

    // Read Access for CartSummary

    /// Returns all current cart items as an array
    /// - Returns: Array of `CartItem` values
    func allItems() -> [CartItem] {
        Array(cartItems.values)
    }

    /// Total number of individual units across all line itemss
    /// - Returns: Sum of all quantities
    func totalItemCount() -> Int {
        cartItems.values.reduce(0) { $0 + $1.quantity }
    }
}