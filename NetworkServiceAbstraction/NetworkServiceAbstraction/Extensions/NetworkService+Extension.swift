import Foundation

// MARK: NetworkService Default Implementations
extension NetworkService {
    func logRequestStarted() {
        print("Request Started...")
    }
    
    func logRequestFinished() {
        print("Request Finished...")
    }
    
    func handleError(_ error: NetworkError) {
        print("Handled Error: \(error.description)")
    }
}
