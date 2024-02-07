import Foundation
import FirebaseDatabase

class RealtimeDatabaseManager {
    
    // MARK: Variables
    
    static let shared = RealtimeDatabaseManager()
    private let databaseRef = Database.database().reference()
    var refHandle = DatabaseHandle()
    var isPagination = false
    
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
    
    func getPostsFromRTDatabase(startingAfter start: String? = nil, limit: UInt = 10, completion: @escaping ([Post]) -> Void) {
        var query = databaseRef.child("posts").queryOrderedByKey().queryLimited(toFirst: limit)
        if let start = start {
            // Query posts starting after the last retrieved post ID
            query = query.queryStarting(afterValue: start)
        }

        query.observeSingleEvent(of: .value) { snapshot in
            var posts: [Post] = []

            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot,
                    let postData = childSnapshot.value as? [String: Any] else { continue }

                let post = Post(
                    postId: childSnapshot.key,
                    userName: postData["userName"] as? String ?? "",
                    userImageUrl: postData["userImageUrl"] as? String ?? "",
                    content: postData["content"] as? String ?? "",
                    imageUrls: postData["imageUrls"] as? [String] ?? [],
                    likes: postData["likes"] as? Int ?? 0,
                    comments: postData["comments"] as? [Comment] ?? []
                )

                posts.append(post)
            }
            completion(posts)
        }
    }



}


