import Foundation

print("---------------- SHOPPING CART SYSTEM ----------------\n")

// Products
let macbook = Product(id: 1, name: "MacBook Pro", price: 95_000)
let mouse = Product(id: 2, name: "Magic Mouse", price:  2_000)
let keyboard = Product(id: 3, name: "Magic Keyboard", price:  4_500)
let monitor = Product(id: 4, name: "Dell Monitor", price: 22_000)

// Cart + Summary
let cart = Cart()
let summary = CartSummary(cart: cart)

// Add items
print("--- Adding Items ---")
cart.addItem(macbook)
cart.addItem(mouse, quantity: 2)
cart.addItem(keyboard, quantity: 1)
cart.addItem(monitor)
cart.addItem(mouse, quantity: 1)   // adds to existing qty — now 3

// Show cart
summary.showCartItems()

// Remove one unit
print("--- Remove One Unit ---")
cart.removeItem(productId: 2)         // mouse qty: 3 -> 2
summary.showCartItems()

// Remove all units of a product
print("--- Remove All Units ---")
cart.removeAllUnits(productId: 4)     // remove monitor entirely
summary.showCartItems()

// Balance check before discount
print("--- Subtotal Before Discount ---")
print("  Rs\(cart.totalAmount())")

// Apply discount
print("\n--- Apply 10% Discount ---")
cart.applyDiscount(percentage: 10)
summary.showSummary()

// Remove discount and reapply
print("--- Remove Discount ---")
cart.removeDiscount()
summary.showSummary()

print("--- Apply 15% Discount ---")
cart.applyDiscount(percentage: 15)
summary.showSummary()

// Invalid discount
print("--- Invalid Discount ---")
cart.applyDiscount(percentage: 110)

// Clear cart
print("--- Clear Cart ---")
cart.clearCart()
summary.showCartItems()
