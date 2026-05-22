import Foundation

/// Responsible only for displaying cart contents and pricing.
/// Follows Single Responsibility — all print logic lives here,
///         keeping Cart focused purely on state management.
struct CartSummary {

    /// The cart to display
    private let cart: Cart

    /// Parameter cart: The cart whose contents will be displayed
    init(cart: Cart) {
        self.cart = cart
    }

    /// Prints each item in the cart with id, name, quantity, and line total
    func showCartItems() {
        let items = cart.allItems()

        print("\n---------- CART ITEMS ----------")

        guard !items.isEmpty else {
            print("  Cart is empty.")
            print("--------------------------------\n")
            return
        }

        for item in items {
            print(
                "  ID: \(item.product.id)" +
                " | \(item.product.name)" +
                " | Rs\(item.product.price) x \(item.quantity)" +
                " = Rs\(item.lineTotal)"
            )
        }
        print("--------------------------------\n")
    }

    /// Prints a full summary: item count, subtotal, discount, and final amount
    func showSummary() {
        print("\n---------- CART SUMMARY ----------")
        print("  Total Units : \(cart.totalItemCount())")
        print("  Subtotal : Rs\(cart.totalAmount())")
        print("  Discount : \(cart.discountPercentage)%")
        print("  Discount Value : Rs\(cart.totalAmount() * cart.discountPercentage / 100)")
        print("  Final Amount : Rs\(String(format: "%.2f", cart.finalAmount()))")
        print("----------------------------------\n")
    }
}