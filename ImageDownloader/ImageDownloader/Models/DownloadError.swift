import Foundation

/// Describes every way an image download can fail

enum DownloadError: Error, LocalizedError {

    /// The URL string could not be parsed into a valid `URL`
    case invalidURL

    /// The server's response was not a valid HTTP response
    case invalidResponse

    /// The server responded with a non-2xx HTTP status code
    ///
    /// - Parameter code: The actual status code returned (e.g. `404`, `503`).
    case badStatusCode(Int)

    /// The server returned HTTP 200 but the response body was empty
    case emptyData

    /// `FileManager` could not write the downloaded data to disk
    case saveFailed

    /// A readable explanation of the failure
    var errorDescription: String? {
        switch self {
        case .invalidURL:           return "The URL string is malformed."
        case .invalidResponse:      return "The response was not a valid HTTP response."
        case .badStatusCode(let c): return "Server returned status code \(c)."
        case .emptyData:            return "Server returned an empty response body."
        case .saveFailed:           return "Could not write file to disk."
        }
    }
}
