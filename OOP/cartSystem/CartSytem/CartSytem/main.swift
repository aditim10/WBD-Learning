import Foundation

print("============= SHOPPING CART SYSTEM =============\n")

// MARK: Products

let macbook = Product(
    id: 1,
    name: "MacBook Pro",
    price: 95000
)

let mouse = Product(
    id: 2,
    name: "Magic Mouse",
    price: 2000
)

let keyboard = Product(
    id: 3,
    name: "Magic Keyboard",
    price: 4500
)

let monitor = Product(
    id: 4,
    name: "Dell Monitor",
    price: 22000
)

// MARK: Cart Setup

let cart = Cart()

let cartSummary = CartSummary(cart: cart)

do {

    // MARK: Add Items

    try cart.addItem(macbook)

    try cart.addItem(
        mouse,
        quantity: 2
    )

    try cart.addItem(
        keyboard,
        quantity: 1
    )

    try cart.addItem(monitor)

    // MARK: Apply Item Discounts

    try cart.applyItemDiscount(
        productId: 2,
        percentage: 10
    )

    try cart.applyItemDiscount(
        productId: 3,
        percentage: 5
    )

    // MARK: Apply Cart Discount

    try cart.applyCartDiscount(
        percentage: 15
    )

    // MARK: Display Cart

    cartSummary.showCartItems()

    // MARK: Display Summary

    cartSummary.showSummary()

    // MARK: Remove Single Quantity

    try cart.removeSingleItem(
        productId: 2
    )

    // MARK: Remove Entire Product

    try cart.removeProduct(
        productId: 4
    )

    // MARK: Display Updated Cart

    cartSummary.showCartItems()

    cartSummary.showSummary()

    // MARK: Clear Cart

    cart.clearCart()

    cartSummary.showCartItems()

} catch CartError.invalidQuantity {

    print("Invalid quantity entered.")

} catch CartError.invalidDiscount {

    print("Invalid discount percentage.")

} catch CartError.productNotFound {

    print("Requested product not found in cart.")

} catch {

    print("Unexpected error occurred.")
}
