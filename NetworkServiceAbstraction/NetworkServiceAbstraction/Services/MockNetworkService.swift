import Foundation

// MARK: MockNetworkService (Test / Preview Service)
// A fake implementation of NetworkService that returns predictable data.
// Used during:
//   - Unit testing (inject this instead of APIService)
//   - SwiftUI previews (no real network needed)
//   - Development before the API is ready
final class MockNetworkService: NetworkService {
    
    func fetchUsers(
        completion: @escaping (Result<[User], NetworkError>) -> Void
    ) {
        logRequestStarted()
        
        // Controlled, predictable data — great for testing UI layout
        // and ViewModel logic without network dependency.
        let mockUsers = [
            User(id: 101, name: "Mock User 1"),
            User(id: 102, name: "Mock User 2")
        ]
        
        completion(.success(mockUsers))
        
        logRequestFinished()
    }
}
