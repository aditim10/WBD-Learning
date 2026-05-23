import Foundation

// MARK: Network Error
// Defines all possible failure cases for network operations
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed
    case requestFailed
    case unknownError
}

// MARK: CustomStringConvertible
// Protocol extension that provides human-readable error messages
extension NetworkError: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .invalidURL:       return "Invalid URL"
        case .noData:           return "No Data Found"
        case .decodingFailed:   return "Data Decoding Failed"
        case .requestFailed:    return "Network Request Failed"
        case .unknownError:     return "Unknown Error Occurred"
        }
    }
}
