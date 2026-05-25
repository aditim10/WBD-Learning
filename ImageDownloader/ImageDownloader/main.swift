import Foundation

// MARK: URLs

// picsum.photos serves a deterministic image per seed value,
// making results reproducible across runs.
let imageURLs = [
    "https://picsum.photos/seed/a/300/300",
    "https://picsum.photos/seed/b/300/300",
    "https://picsum.photos/seed/c/300/300",
    "https://picsum.photos/seed/d/300/300",
    "https://picsum.photos/seed/e/300/300",
    "https://picsum.photos/seed/a/300/300",   // duplicate - expect deduplication log
]

// MARK: Run

Logger.log("Image Downloader Demo")
Logger.log("-------------------------------------------")
Logger.log("URLs to process : \(imageURLs.count)")
Logger.log("Unique URLs     : \(Set(imageURLs).count)")
Logger.log("Max ops         : \(Constants.maxConcurrentOperations)")
Logger.log("Semaphore slots : \(Constants.maxConcurrentNetworkCalls)")
Logger.log("Max retries     : \(Constants.maxRetryAttempts)")
Logger.log("-----------------------------------------------\n")

let manager = ImageDownloadManager()

// downloadImages returns the enqueued operations.
// Dependencies between operations can be added here before they start:
//   ops[1].addDependency(ops[0])  // ops[1] waits for ops[0] to finish
let _ = manager.downloadImages(from: imageURLs)

// Block the main thread until all operations complete
manager.waitUntilFinished()

manager.printSummary()

// MARK: Cancellation demo (uncomment to try)

// Shows how in-flight operations check isCancelled and exit early:
//
// let manager2 = ImageDownloadManager()
// manager2.downloadImages(from: imageURLs)
// DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
//     Logger.log("Triggering cancellation...", level: .warning)
//     manager2.cancelAll()
// }
// manager2.waitUntilFinished()
// manager2.printSummary()
