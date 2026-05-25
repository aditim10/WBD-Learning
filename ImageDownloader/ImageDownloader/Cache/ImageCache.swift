import Foundation

/// A thread-safe, in-memory cache for downloaded image data

final class ImageCache {

    // MARK: Shared instance
    /// The application-wide shared cache instance

    static let shared = ImageCache()

    private init() {}

    // MARK: Private storage

    private var store: [URL: Data] = [:]

    private let queue = DispatchQueue(
        label: "com.imagedownloader.cache.queue",
        attributes: .concurrent
    )

    // MARK: Reading

    /// Returns the cached data for the given URL, or `nil` if not present
    /// - Parameter url: The remote URL whose data was previously cached
    /// - Returns: The raw image bytes, or `nil` if the URL is not cached

    func data(for url: URL) -> Data? {
        
        queue.sync { store[url] }
    }

    /// Returns whether data for the given URL exists in the cache
    /// - Parameter url: The remote URL to check
    /// - Returns: `true` if data is present; `false` otherwise

    func contains(url: URL) -> Bool {
        queue.sync { store[url] != nil }
    }

    /// The number of entries currently held in the cache
    var count: Int {
        queue.sync { store.count }
    }

    // MARK: Writing

    /// Stores raw image data in the cache, associated with a remote UR
    ///
    /// - Parameters:
    ///   - data: The raw bytes to cache
    ///   - url: The remote URL to use as the cache key
    func save(data: Data, for url: URL) {
        queue.async(flags: .barrier) {
            self.store[url] = data
            Logger.log("Cached \(url.lastPathComponent) (\(data.count) bytes)")
        }
    }

    /// Removes the cached data for a single URL
    /// - Parameter url: The remote URL whose entry should be removed
    func remove(for url: URL) {
        queue.async(flags: .barrier) {
            self.store.removeValue(forKey: url)
        }
    }

    /// Removes all entries from the cache
    func removeAll() {
        queue.async(flags: .barrier) {
            self.store.removeAll()
            Logger.log("Cache cleared.", level: .warning)
        }
    }
}
