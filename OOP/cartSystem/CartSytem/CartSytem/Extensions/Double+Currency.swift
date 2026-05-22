import Foundation

extension Double {

    /// Converts value into formatted currency string
    var formattedCurrency: String {

        return String(format: "Rs%.2f", self)
    }
}
