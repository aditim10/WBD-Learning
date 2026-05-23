import Foundation

// MARK: UserViewModel
//   1. It holds a `NetworkService` protocol type — not APIService directly
//      This is Dependency Injection: the concrete service is passed in from outside
//   2. `private let` — the service is injected once at init and never replaced
//   3. `final class` — ViewModels are also not meant to be subclassed
final class UserViewModel {
    private let networkService: NetworkService
    
    // MARK: Dependency Injection
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: Public Interface
    func loadUsers() {
        networkService.fetchUsers { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let users):
                // Happy path — pass users to display logic
                self.displayUsers(users)
                
            case .failure(let error):
                // Error path — pass error to error handling logic
                self.handleNetworkError(error)
            }
        }
    }
    
    // MARK: Private Helpers
    
    private func displayUsers(_ users: [User]) {
        print("\nUsers Loaded Successfully:\n")
        for user in users {
            print("ID: \(user.id), Name: \(user.name)")
        }
    }
    
    private func handleNetworkError(_ error: NetworkError) {
        print("\nFailed To Load Users")
        print("Error: \(error.description)")
    }
}
