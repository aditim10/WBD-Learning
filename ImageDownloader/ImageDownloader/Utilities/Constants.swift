import Foundation

/// Application-wide configuration constants
/// All tunable values are centralised here so behaviour can be adjusted
/// in one place without modifying individual components
enum Constants {

    // MARK: OperationQueue

    /// The maximum number of download operations that may execute concurrently
    static let maxConcurrentOperations: Int = 4

    // MARK: Semaphore

    /// The maximum number of active network calls permitted at any one time
    static let maxConcurrentNetworkCalls: Int = 3

    // MARK: Retry

    /// The maximum number of download attempts before an operation fails permanently.
    static let maxRetryAttempts: Int = 3

    /// The base delay in seconds applied between retry attempts
    static let retryBaseDelay: Double = 1.0
}
