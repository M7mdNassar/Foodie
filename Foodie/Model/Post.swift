
import Foundation
import UIKit

struct Post {
    var postId: String
    var username: String?
    var content: String
    var images: [UIImage?]
    var likes: Int
    var comments: [Comment]
}

struct Comment {
    var username: String
    var text: String
}


struct Story{
    var username: String
    var image: UIImage
}
