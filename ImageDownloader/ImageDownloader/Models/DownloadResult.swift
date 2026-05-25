import Foundation

/// Represents the outcome of a successfully completed image download

struct DownloadResult {

    /// The original remote URL that was requested
    let url: URL

    /// The absolute file-system path where the downloaded data was saved.
    /// Example: `/Users/aditi/ImageDownloader/seed-a-300.jpg`
    let localPath: String

    /// The number of bytes in the downloaded file

    /// A value of `0` indicates the result was served from the in-memory
    /// cache and no bytes were transferred over the network
    let fileSize: Int

    /// The last path component of the remote URL, used as the local filename
    var fileName: String {
        url.lastPathComponent
    }
}
