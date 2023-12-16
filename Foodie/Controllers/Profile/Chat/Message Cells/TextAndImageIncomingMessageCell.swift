
import UIKit

class TextAndImageIncomingMessageCell: UITableViewCell {

    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var backgroundMessage: UIView!
    
    @IBOutlet weak var messageTextLabel: UILabel!
    
    @IBOutlet weak var messageImageView: UIImageView!
    
    
    // MARK: Methods
    func configure(messageText: String?, messageImage: UIImage?, userImageUrl: String) {
        
        self.backgroundMessage.backgroundColor = .foodieLightGreen
        self.backgroundMessage.layer.cornerRadius = 15.0
        self.backgroundMessage.layer.masksToBounds = true
        
        if let messageText = messageText{
            self.messageTextLabel.text = messageText
        }
        loadUserImage(urlString : userImageUrl)
        
        // Set initial corner radius and masking
        self.messageImageView.layer.cornerRadius = 15.0
        self.messageImageView.layer.masksToBounds = true
        
        if let messageImage = messageImage{
            // Calculate image dimensions
            let dimensions = calculateImageDimensions(for: messageImage)
            
            // Update image view frame constraints
            self.messageImageView.widthAnchor.constraint(equalToConstant: dimensions.width).isActive = true
            self.messageImageView.heightAnchor.constraint(equalToConstant: dimensions.height).isActive = true
            
            // Set image and content mode
            self.messageImageView.image = messageImage
            
            // Calculate aspect ratio
            let aspectRatio = dimensions.width / dimensions.height
            
            if dimensions.width > dimensions.height {
                self.messageImageView.contentMode = .scaleAspectFill // Landscape
            } else {
                self.messageImageView.contentMode = .scaleAspectFit // Portrait
            }
            
            // Update aspect ratio constraint
            for constraint in self.messageImageView.constraints {
                if constraint.firstAttribute == .width && constraint.secondAttribute == .height {
                    // Assuming you have only one aspect ratio constraint
                    constraint.isActive = false // deactivate existing constraint
                    let aspectRatioConstraint = self.messageImageView.widthAnchor.constraint(equalTo: self.messageImageView.heightAnchor, multiplier: aspectRatio)
                    aspectRatioConstraint.isActive = true
                }
            }
        }
        
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
    
    
    func calculateImageDimensions(for image: UIImage) -> (width: CGFloat, height: CGFloat) {
        let maxWidth = UIScreen.main.bounds.width * 0.7 , minWidth = 150.0

        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let aspectRatio = imageWidth / imageHeight

        // Calculate width based on maximum width and aspect ratio
        let width = min(maxWidth, max(minWidth, imageWidth))
        let height = width / aspectRatio

        return (width, height)
    }

    
    
}


