// Simulates real-world async API calls using @escaping closures
// Demonstrates weak self to avoid retain cycles in escaping closures
// No top-level executable code here — run from main.swift

import Foundation

// MARK: API Service

class APIService {

    func fetchData(endpoint: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("Fetching from \(endpoint)...")

        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let response = "{ \"data\": \"Hello from \(endpoint)\" }"
            DispatchQueue.main.async {
                completion(.success(response))
            }
        }
    }

    func fetchWithError(completion: @escaping (Result<String, Error>) -> Void) {
        print("Fetching with simulated error...")

        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            DispatchQueue.main.async {
                let error = NSError(domain: "NetworkError", code: 404,
                                    userInfo: [NSLocalizedDescriptionKey: "Resource not found"])
                completion(.failure(error))
            }
        }
    }
}

// MARK: ViewController

class ViewController {

    let api = APIService()
    var receivedData: String?

    func loadUserData() {
        api.fetchData(endpoint: "/users") { [weak self] result in
            guard let self = self else {
                print("ViewController was deallocated before callback fired")
                return
            }
            switch result {
            case .success(let data):
                self.receivedData = data
                print("Success: \(data)")
                print("UI updated with user data")
            case .failure(let error):
                print("Error loading user data: \(error.localizedDescription)")
            }
        }
    }

    func loadWithErrorHandling() {
        api.fetchWithError { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print("Unexpected success: \(data)")
            case .failure(let error):
                print("Handled error gracefully: \(error.localizedDescription)")
                self.showErrorAlert(message: error.localizedDescription)
            }
        }
    }

    private func showErrorAlert(message: String) {
        print("Showing alert: \(message)")
    }

    deinit {
        print("ViewController deinitialized")
    }
}

// MARK: DataPipeline (chained async)

class DataPipeline {

    let api = APIService()

    func fetchSecureData(completion: @escaping (String) -> Void) {
        print("\nStarting chained async pipeline...")

        api.fetchData(endpoint: "/auth/token") { [weak self] tokenResult in
            guard let self = self else { return }

            switch tokenResult {
            case .success(let token):
                print("Got token: \(token)")
                self.api.fetchData(endpoint: "/secure/data") { [weak self] dataResult in
                    guard self != nil else { return }
                    switch dataResult {
                    case .success(let data): completion(data)
                    case .failure(let error): print("Secure fetch failed: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Auth failed: \(error.localizedDescription)")
            }
        }
    }

    deinit {
        print("DataPipeline deinitialized")
    }
}
