import Foundation

/// Handles cart operations and pricing logic
final class Cart: Discountable {

    // MARK: Properties

    /// Stores cart items using productId as key
    private var cartItems: [Int: CartItem] = [:]

    private(set) var cartDiscountPercentage: Double = 0.0

    // MARK: Add Item

    /// Adds product into cart.
    /// - Parameters:
    ///   - product: Product to add
    ///   - quantity: Quantity to add
    /// - Throws:
    ///   CartError.invalidQuantity
    func addItem(
        _ product: Product,
        quantity: Int = 1
    ) throws {

        try validateQuantity(quantity)

        if cartItems[product.id] != nil {

            cartItems[product.id]?.quantity += quantity

        } else {

            let cartItem = CartItem(
                product: product,
                quantity: quantity,
                itemDiscountPercentage: 0
            )

            cartItems[product.id] = cartItem
        }
    }

    // MARK: Remove Item

    /// Removes one quantity of product
    /// - Parameter productId:
    ///   Product identifier
    /// - Throws:
    ///   CartError.productNotFound
    func removeSingleItem(
        productId: Int
    ) throws {

        guard var cartItem = cartItems[productId] else {
            throw CartError.productNotFound
        }

        if cartItem.quantity > 1 {

            cartItem.quantity -= 1

            cartItems[productId] = cartItem

        } else {

            cartItems.removeValue(forKey: productId)
        }
    }

    // MARK: Remove Entire Product

    /// Removes all quantities of a product
    /// - Parameter productId:
    ///   Product identifier
    /// - Throws:
    ///   CartError.productNotFound
    func removeProduct(
        productId: Int
    ) throws {

        guard cartItems[productId] != nil else {
            throw CartError.productNotFound
        }

        cartItems.removeValue(forKey: productId)
    }

    // MARK: Clear Cart

    /// Removes all cart items
    func clearCart() {

        cartItems.removeAll()
    }

    // MARK: Item Discount

    /// Applies item level discount
    /// - Parameters:
    ///   - productId: Product identifier
    ///   - percentage: Discount percentage
    /// - Throws:
    ///   CartError.productNotFound
    ///   CartError.invalidDiscount
    func applyItemDiscount(
        productId: Int,
        percentage: Double
    ) throws {

        try validateDiscountPercentage(percentage)

        guard var cartItem = cartItems[productId] else {
            throw CartError.productNotFound
        }

        cartItem.itemDiscountPercentage = percentage

        cartItems[productId] = cartItem
    }

    // MARK: Cart Discount

    /// Applies overall cart discount
    /// - Parameter percentage:
    ///   Discount percentage
    /// - Throws:
    ///   CartError.invalidDiscount
    func applyCartDiscount(
        percentage: Double
    ) throws {

        try validateDiscountPercentage(percentage)

        cartDiscountPercentage = percentage
    }

    /// Removes cart level discount
    func removeCartDiscount() {

        cartDiscountPercentage = 0
    }

    // MARK: Pricing

    /// Calculates subtotal before discounts
    /// - Returns:
    ///   Cart subtotal
    func calculateSubtotal() -> Double {

        cartItems.values.reduce(0) { runningTotal, cartItem in

            runningTotal + cartItem.lineSubtotal
        }
    }

    /// Calculates item level discount total
    /// - Returns:
    ///   Total item discount
    func calculateItemDiscountTotal() -> Double {

        cartItems.values.reduce(0) { runningTotal, cartItem in

            runningTotal + cartItem.lineDiscountAmount
        }
    }

    /// Calculates subtotal after item discounts
    /// - Returns:
    ///   Discounted subtotal
    func calculateDiscountedSubtotal() -> Double {

        calculateSubtotal() - calculateItemDiscountTotal()
    }

    /// Calculates cart level discount amount
    /// - Returns:
    ///   Cart discount value
    func calculateCartDiscountAmount() -> Double {

        let discountedSubtotal = calculateDiscountedSubtotal()

        return discountedSubtotal * cartDiscountPercentage / 100
    }

    /// Calculates final payable amount
    /// - Returns:
    ///   Final amount
    func calculateFinalAmount() -> Double {

        calculateDiscountedSubtotal() - calculateCartDiscountAmount()
    }

    // MARK: Read Methods

    /// Returns all cart items
    /// - Returns:
    ///   Array of cart items
    func fetchCartItems() -> [CartItem] {

        Array(cartItems.values)
    }

    /// Returns total quantity count
    /// - Returns:
    ///   Total quantity
    func fetchTotalItemCount() -> Int {

        cartItems.values.reduce(0) { total, cartItem in

            total + cartItem.quantity
        }
    }

    // MARK: Validation

    /// Validates quantity value
    /// - Parameter quantity:
    ///   Quantity to validate
    /// - Throws:
    ///   CartError.invalidQuantity
    private func validateQuantity(
        _ quantity: Int
    ) throws {

        guard quantity > 0 else {
            throw CartError.invalidQuantity
        }
    }

    /// Validates discount percentage
    /// - Parameter percentage:
    ///   Discount value
    /// - Throws:
    ///   CartError.invalidDiscount
    private func validateDiscountPercentage(
        _ percentage: Double
    ) throws {

        guard percentage >= 0 && percentage <= 100 else {
            throw CartError.invalidDiscount
        }
    }
}
