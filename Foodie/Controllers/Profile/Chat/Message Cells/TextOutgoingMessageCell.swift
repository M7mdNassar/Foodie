

import UIKit

class TextOutgoingMessageCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var backgroundMessage: UIView!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    // MARK: Methods
    func configure(messageText: String?, userImageUrl: String) {
        
        self.backgroundMessage.backgroundColor = .foodieLightGreen
        self.backgroundMessage.layer.cornerRadius = 15.0
        self.backgroundMessage.layer.masksToBounds = true
      
        if let messageText = messageText{
            self.messageTextLabel.text = messageText
        }
        loadUserImage(urlString : userImageUrl)
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
