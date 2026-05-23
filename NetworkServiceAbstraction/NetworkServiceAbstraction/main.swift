import Foundation

// MARK: Scenario 1 — Real API
// In production, this is the service we inject
print("------------ REAL API SERVICE ------------\n")

let apiService = APIService()
let apiViewModel = UserViewModel(networkService: apiService)
apiViewModel.loadUsers()

// MARK: Scenario 2 — Mock (Success)
// Useful during development, UI testing, and SwiftUI previews
print("----------- MOCK SERVICE ------------\n")

let mockService = MockNetworkService()
let mockViewModel = UserViewModel(networkService: mockService)
mockViewModel.loadUsers()

// MARK: Scenario 3 Mock (Failure)
// Validates that error handling in the ViewModel works correctly.
print("------------ FAILED SERVICE ------------\n")

let failedService = FailedMockService()
let failedViewModel = UserViewModel(networkService: failedService)
failedViewModel.loadUsers()
