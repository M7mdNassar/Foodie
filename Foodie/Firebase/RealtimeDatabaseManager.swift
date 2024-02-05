import Foundation
import FirebaseDatabase

class RealtimeDatabaseManager {
    
    // MARK: Variables
    
    static let shared = RealtimeDatabaseManager()
    private let databaseRef = Database.database().reference()
    var refHandle = DatabaseHandle()
    
    // MARK: Add post to Realtime Database
    
    func addPost(post: Post) {
        let postData: [String: Any] = [
            "postId": post.postId,
            "userImageUrl": post.userImageUrl ?? "",
            "userName": post.userName,
            "content": post.content,
            "imageUrls": post.imageUrls,
            "likes" :post.likes,
            "comments" : post.comments
        ]
        
        let postRef = databaseRef.child("posts").childByAutoId()
        postRef.setValue(postData) { error, _ in
            if let error = error {
                print("Error adding post: \(error.localizedDescription)")
            } else {
                print("Post added successfully!")
            }
        }
    }
    
    
    // MARK: get posts from Firebase Realtime Database
    
      func getPostsFromRTDatabase(completion: @escaping ([Post]) -> Void) {
    
    
          refHandle = databaseRef.child("posts").observe(DataEventType.value, with: { snapshot in
            
              var posts: [Post] = []
              
              for child in snapshot.children {
                  guard let childSnapshot = child as? DataSnapshot,
                              let postData = childSnapshot.value as? [String: Any] else { continue }
                    
                      let post = Post(
                               postId: childSnapshot.key,
                               userName: postData["userName"] as? String ?? "",
                               userImageUrl : postData["userImageUrl"] as? String ?? "", 
                               content: postData["content"] as? String ?? "",
                               imageUrls: postData["imageUrls"] as? [String?] ?? [],
                               likes: postData["likes"] as? Int ?? 0,
                               comments: postData["comments"] as? [Comment] ?? [] // Handle comments later
                           )
//                  posts.append(post)
                  posts.insert(post, at: 0)
              }
              completion(posts)
              
          })
         
      }
    
}


