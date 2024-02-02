
import FirebaseFirestoreSwift    // let us covert User instance to document data
import Foundation
import Firebase

struct User : Codable , Equatable {
    var id = ""
    var userName : String
    var email : String
    var pushId = ""
    var avatarLink = ""
    var date = ""
    var phoneNumber : String
    var country: String
    
    
    static var currentId : String {
        return Auth.auth().currentUser!.uid
    }
    
    
    static var currentUser : User? {
        if Auth.auth().currentUser != nil{
            
            if let data = userDefaults.data(forKey: kCURRENTUSER){
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: data)
                    
                    return userObject
                }catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        return nil
    }
    
    static func == (lhs: User , rhs: User) -> Bool{
        lhs.id == rhs.id
    }
    
}



func saveUserLocally(user: User) {
    
    let encode = JSONEncoder()
    do{
        let data = try encode.encode(user)
        userDefaults.set(data, forKey: kCURRENTUSER)
    }catch{
        print(error.localizedDescription)
    }
}
