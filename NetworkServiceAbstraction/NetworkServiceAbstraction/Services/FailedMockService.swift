import Foundation

// MARK: - FailedMockService (Error Simulation Service)
// Deliberately always returns a failure
final class FailedMockService: NetworkService {
    
    func fetchUsers(
        completion: @escaping (Result<[User], NetworkError>) -> Void
    ) {
        logRequestStarted()
        
        // Simulates a network failure — could be no internet,
        // server timeout, 5xx response, etc.
        completion(.failure(.requestFailed))
        
        logRequestFinished()
    }
}
