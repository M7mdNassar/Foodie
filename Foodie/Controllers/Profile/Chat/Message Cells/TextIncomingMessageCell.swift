
import UIKit

class TextIncomingMessageCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var backgroundMessage: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    // MARK: Methods
    func configure(messageText: String?, userImageUrl: String) {
        self.backgroundColor = .clear
        self.backgroundMessage.backgroundColor = .foodieLightBlue
        self.backgroundMessage.layer.cornerRadius = 15.0
        self.backgroundMessage.layer.masksToBounds = true
      
        
        if let messageText = messageText{
            self.messageTextLabel.text = messageText
        }
        self.userImageView.load(from : userImageUrl)
    }

}
