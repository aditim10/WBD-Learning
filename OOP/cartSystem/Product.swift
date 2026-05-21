import Foundation

/// Represents a product available for purchase
/// Conforms to 'Hashable' so it can be used as a dictionary key in the cart
struct Product: Hashable {

    /// Unique identifier for the product
    let id: Int

    /// Display name of the product
    let name: String

    /// Price of the product in Rs.
    let price: Double

    // Hashable conformance — equality based on id alone
    // so two products with the same id are treated as the same item
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
}