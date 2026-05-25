import Foundation

/// Coordinates concurrent image downloads using an `OperationQueue` and a
/// shared `DispatchSemaphore`
///
/// `ImageDownloadManager` is the primary interface for initiating downloads.
/// It handles scheduling, network throttling, deduplication, cancellation,
/// and success/failure statistics.

final class ImageDownloadManager {

    // MARK: Private properties

    private lazy var operationQueue: OperationQueue = {
        let q = OperationQueue()
        q.name = "com.imagedownloader.operationqueue"
        q.maxConcurrentOperationCount = Constants.maxConcurrentOperations
        q.qualityOfService = .userInitiated
        return q
    }()

    private let networkSemaphore = DispatchSemaphore(value: Constants.maxConcurrentNetworkCalls)

    // Tracks in-flight operations keyed by URL for deduplication.
    // Accessed from multiple threads, so all reads and writes are
    // wrapped with opsLock.
    private var activeOperations: [URL: ImageDownloadOperation] = [:]
    private let opsLock = NSLock()

    // Separate lock from opsLock to avoid holding two locks simultaneously,
    // which risks deadlock.
    private var successCount = 0
    private var failureCount = 0
    private let statsLock = NSLock()

    // MARK: Public API

    /// Enqueues download operations for each URL string in the provided array.
    ///
    /// Malformed URL strings are skipped and logged as warnings. If a URL is
    /// already being downloaded, the duplicate request is silently dropped.
    ///
    /// - Parameter urlStrings: An array of remote URL strings to download.
    /// - Returns: The `ImageDownloadOperation` instances that were enqueued,
    ///   in the same order as the valid input URLs. Use the returned operations
    ///   to establish inter-operation dependencies if required.
    @discardableResult
    func downloadImages(from urlStrings: [String]) -> [ImageDownloadOperation] {
        var operations: [ImageDownloadOperation] = []

        for urlString in urlStrings {
            guard let url = URL(string: urlString) else {
                Logger.log("Skipping invalid URL: \(urlString)", level: .warning)
                continue
            }
            if let op = enqueue(url: url) {
                operations.append(op)
            }
        }

        Logger.log("Enqueued \(operations.count) operations (queue depth: \(operationQueue.operationCount))")
        return operations
    }

    /// Blocks the calling thread until all enqueued operations have finished.
    /// - Warning: Do not call this from the main thread in a UI application -
    ///   doing so will freeze the interface. It is safe in a command-line context
    ///   where the main thread has no run loop to service.
    func waitUntilFinished() {
        operationQueue.waitUntilAllOperationsAreFinished()
    }

    /// Cancels all queued and in-flight operations immediately
    func cancelAll() {
        // Clear tracking dictionary first so completion blocks that fire
        // during cancellation find no entries to clean up
        opsLock.lock()
        activeOperations.removeAll()
        opsLock.unlock()

        operationQueue.cancelAllOperations()
        Logger.log("All downloads cancelled.", level: .warning)
    }

    /// Logs a summary of total successes, failures, and cached entries
    /// accumulated since this manager was created.
    func printSummary() {
        // Snapshot counts under lock, then log outside it to avoid
        // holding the lock longer than necessary
        statsLock.lock()
        let s = successCount
        let f = failureCount
        statsLock.unlock()

        Logger.log("----------------------------------")
        Logger.log("Summary: \(s) succeeded, \(f) failed, \(ImageCache.shared.count) cached")
        Logger.log("----------------------------------")
    }

    // MARK: Private helpers

    // Creates and enqueues a single download operation for the given URL.
    // Returns nil if an operation for this URL is already active (deduplication)
    private func enqueue(url: URL) -> ImageDownloadOperation? {
        // Lock before the existence check AND before inserting, so no other
        // thread can slip in between the two steps and create a duplicate
        opsLock.lock()

        if activeOperations[url] != nil {
            opsLock.unlock()
            Logger.log("Deduplicated: \(url.lastPathComponent) already in queue")
            return nil
        }

        let op = ImageDownloadOperation(imageURL: url, semaphore: networkSemaphore)
        activeOperations[url] = op
        opsLock.unlock()

        // Set up the completion handler outside the lock - no mutation here,
        // and keeping the lock duration short improves throughput
        op.onCompletion = { [weak self] result in
            guard let self else { return }

            // Remove from tracking so the same URL can be re-downloaded later
            self.opsLock.lock()
            self.activeOperations.removeValue(forKey: url)
            self.opsLock.unlock()

            // Update stats under their own lock
            self.statsLock.lock()
            switch result {
            case .success: self.successCount += 1
            case .failure: self.failureCount += 1
            }
            self.statsLock.unlock()
        }

        operationQueue.addOperation(op)
        return op
    }
}
