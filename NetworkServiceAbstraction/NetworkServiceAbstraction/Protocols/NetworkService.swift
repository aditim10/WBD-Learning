import Foundation

// MARK: NetworkService Protocol
protocol NetworkService {
    func fetchUsers(
        completion: @escaping (Result<[User], NetworkError>) -> Void
    )
}
