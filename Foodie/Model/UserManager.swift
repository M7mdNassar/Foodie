
import Foundation

struct UserManager {
    
    static func saveUserToUserDefaults(user: User) {
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            UserDefaults.standard.set(userData, forKey: "currentUser")
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
        }
    }

    static func getUserFromUserDefaults() -> User? {
        if let userData = UserDefaults.standard.data(forKey: "currentUser") {
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: userData)
                return user
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }
}
