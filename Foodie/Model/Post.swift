
import Foundation
import UIKit

struct Post {
    var postId: String
    var userName: String
    var userImageUrl: String?
    var content: String
    var imageUrls: [String?]
    var likes: Int
    var comments: [Comment]
}

struct Comment {
    var userName: String
    var text: String
}


struct Story{
    var userName: String
    var image: UIImage
}
