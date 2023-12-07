

import UIKit

class ImageIncomingMessageCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    
    
    func configure(messageImage: UIImage , userImageUrl: String ){
        self.messageImageView.image = messageImage
        self.messageImageView.layer.cornerRadius = 15.0
        self.messageImageView.layer.masksToBounds = true
        
        loadUserImage(urlString: userImageUrl)

    }
    
    
    func loadUserImage(urlString: String) {
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
