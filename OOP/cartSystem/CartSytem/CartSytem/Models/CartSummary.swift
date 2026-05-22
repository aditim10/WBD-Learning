import Foundation

/// Responsible for displaying cart related information
struct CartSummary {

    // MARK: Properties

    private let cart: Cart

    // MARK: Initializer

    init(cart: Cart) {

        self.cart = cart
    }

    // MARK: Display Cart Items

    /// Displays all cart items
    func showCartItems() {

        let cartItems = cart.fetchCartItems()

        print("\n----------- CART ITEMS -----------")

        guard !cartItems.isEmpty else {

            print("Cart is empty.")

            print("----------------------------------")

            return
        }

        for cartItem in cartItems {

            print(
                """
                ID: \(cartItem.product.id)
                Product: \(cartItem.product.name)
                Price: \(cartItem.product.price.formattedCurrency)
                Quantity: \(cartItem.quantity)
                Item Discount: \(cartItem.itemDiscountPercentage)%
                Final Line Total: \(cartItem.finalLineTotal.formattedCurrency)
                ----------------------------------
                """
            )
        }
    }

    // MARK: Display Summary

    /// Displays pricing summary
    func showSummary() {

        print("\n----------- CART SUMMARY -----------")

        print("Total Items: \(cart.fetchTotalItemCount())")

        print("Subtotal: \(cart.calculateSubtotal().formattedCurrency)")

        print(
            "Item Discounts: \(cart.calculateItemDiscountTotal().formattedCurrency)"
        )

        print(
            "Cart Discount: \(cart.calculateCartDiscountAmount().formattedCurrency)"
        )

        print(
            "Final Amount: \(cart.calculateFinalAmount().formattedCurrency)"
        )

        print("------------------------------------")
    }
}
