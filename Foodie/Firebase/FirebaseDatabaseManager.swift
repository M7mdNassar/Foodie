
import Foundation
import FirebaseDatabase
import UIKit

class FirebaseDatabaseManager {
    static let shared = FirebaseDatabaseManager()
    public let databaseRef = Database.database().reference().child("posts")
    
    func addPost(username: String, userImageUrl: String, content: String, imageUrls: [String], completion: @escaping (Error?) -> Void) {
        let postId = databaseRef.childByAutoId().key ?? ""
        let postDict: [String: Any] = [
            "postId": postId,
            "username": username,
            "userImage": userImageUrl,
            "content": content,
            "imageUrls": imageUrls
        ]
        
        databaseRef.child(postId).setValue(postDict) { (error, ref) in
            completion(error)
        }
    }
    
    
    
   
    
}
