import Foundation

/// A lightweight, thread-safe logger that prefixes each message with a
/// severity icon, timestamp, and the name of the calling thread.

final class Logger {

    // MARK: Private

    // A serial queue ensures that only one print() runs at a time.
    // Without this, two threads logging simultaneously can produce
    // garbled output like: "[Background[Main] Thread] Starting..."
    private static let serialQueue = DispatchQueue(label: "com.imagedownloader.logger")

    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss.SSS"  // e.g. 14:35:07.284
        return f
    }()

    // MARK: Public

    /// Writes a formatted message to standard output
    /// Output format: `<icon> [HH:mm:ss.SSS] [ThreadName] message`
    ///
    /// - Parameters:
    ///   - message: The text to log.
    ///   - level: The severity of the message. Defaults to `.info`
    static func log(_ message: String, level: Level = .info) {
        serialQueue.async {
            let timestamp = formatter.string(from: Date())
            let thread = threadLabel()
            print("\(level.icon) [\(timestamp)] [\(thread)] \(message)")
        }
    }

    // MARK: Level

    /// The severity of a log message, reflected as a visual icon in output
    enum Level {

        /// Routine informational message
        case info

        /// An operation completed successfully
        case success

        /// A non-fatal condition that warrants attention
        case warning

        /// A failure that prevented an operation from completing
        case error

        /// A plain-text tag prepended to each log line
        ///
        /// Kept to ASCII so output renders correctly in all terminals,
        /// CI environments, and log aggregators.
        var icon: String {
            switch self {
            case .info:    return "[INFO]   "
            case .success: return "[SUCCESS]"
            case .warning: return "[WARNING]"
            case .error:   return "[ERROR]  "
            }
        }
    }

    // MARK: Private helpers

    // Returns a readable label for whichever thread is currently executin
    // Priority: Main -> OperationQueue name -> thread number from description -> fallback
    private static func threadLabel() -> String {
        if Thread.isMainThread { return "Main" }

        if let name = Thread.current.name, !name.isEmpty { return name }

        let desc = Thread.current.description
        if let range = desc.range(of: "number = "),
           let end  = desc[range.upperBound...].range(of: ",") {
            return "Thread-\(desc[range.upperBound..<end.lowerBound])"
        }

        return "Background"
    }
}
