import Foundation

// MARK: APIService

final class APIService: NetworkService {
    
    func fetchUsers(
        completion: @escaping (Result<[User], NetworkError>) -> Void
    ) {
        
        logRequestStarted()
        
        let users = [
            User(id: 1, name: "Aditi"),
            User(id: 2, name: "Ayan"),
            User(id: 3, name: "Sharad")
        ]
        
        completion(.success(users))
        
        logRequestFinished()
    }
}
