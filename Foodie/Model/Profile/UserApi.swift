import Foundation

class UserApi {

    let urlBase = "https://randomuser.me/api/"

    func fetchData() async throws -> UserResult {
        guard let url = URL(string: urlBase) else {
            throw UserApiError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(UserResult.self, from: data)
    }
}

// Define a custom error type for error handling
enum UserApiError: Error {
    case invalidURL
}

