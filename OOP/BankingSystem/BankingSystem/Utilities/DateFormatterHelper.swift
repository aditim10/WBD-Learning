import Foundation

/// Utility helper for reusable date formatters
enum DateFormatterHelper {

    static let transactionDateFormatter: DateFormatter = {

        let formatter = DateFormatter()

        formatter.dateStyle = .medium

        formatter.timeStyle = .short

        return formatter
    }()
}
