

import UIKit

class PostCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var textPostLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var backgroundContentView: UIView!
    @IBOutlet weak var commentsContLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    
    
    func configure(userImage:String? , post: Post){
        loadUserImage(from: userImage!)
        self.userNameLabel.text = post.username
        self.textPostLabel.text = post.content
        self.commentsContLabel.text = String(post.comments.count)
        self.likesCountLabel.text = String(post.likes)
        self.postImageView.image = post.images
        
        self.backgroundContentView.layer.cornerRadius = 20
        
    }
    
    
    
    
    func loadUserImage(from urlString: String) {
       DispatchQueue.global(qos: .userInitiated).async {
           if let imageURL = URL(string: urlString),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {

               DispatchQueue.main.async {
                   self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
                   self.userImageView.image = image
               }
           }
       }
   }

 
    
}
