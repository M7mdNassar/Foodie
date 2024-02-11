import UIKit

class TextAndImageOutgoingMessageCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var backgroundMessage: UIView!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageImageView: UIImageView!

    // MARK: - Methods

    func configure(messageText: String?, messageImage: UIImage?, userImageUrl: String) {
        backgroundColor = .clear
        setupBackground()
        setMessageText(messageText)
        
        self.userImageView.sd_setImage(with: URL(string: userImageUrl))
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2 
        setupMessageImage(messageImage)
    }

    // MARK: - Private Methods

    private func setupBackground() {
        backgroundMessage.backgroundColor = .foodieLightGreen
        backgroundMessage.layer.cornerRadius = 15.0
        backgroundMessage.layer.masksToBounds = true
    }

    private func setMessageText(_ messageText: String?) {
        messageTextLabel.text = messageText
    }

    private func setupMessageImage(_ messageImage: UIImage?) {
        guard let messageImage = messageImage else { return }

        // Calculate dimensions for the image
           let maxWidth: CGFloat = UIScreen.main.bounds.width * 0.7
           let minWidth: CGFloat = 150.0
           let dimensions = messageImage.calculateImageDimensions(maxWidth: maxWidth, minWidth: minWidth)

           // Set up constraints for the messageImageView
           messageImageView.translatesAutoresizingMaskIntoConstraints = false
           messageImageView.widthAnchor.constraint(equalToConstant: dimensions.width).isActive = true
           messageImageView.heightAnchor.constraint(equalToConstant: dimensions.height).isActive = true

           messageImageView.image = messageImage
           messageImageView.layer.cornerRadius = 15.0
           messageImageView.layer.masksToBounds = true

           // Adjust the content mode based on the aspect ratio
           if dimensions.width > dimensions.height {
               messageImageView.contentMode = .scaleAspectFill
           } else {
               messageImageView.contentMode = .scaleAspectFit
           }

           // Ensure existing aspect ratio constraint is removed
           messageImageView.constraints.filter { $0.identifier == "AspectRatioConstraint" }.forEach { $0.isActive = false }

           // Set up aspect ratio constraint
           let aspectRatioConstraint = NSLayoutConstraint(item: messageImageView, attribute: .width, relatedBy: .equal, toItem: messageImageView, attribute: .height, multiplier: dimensions.width / dimensions.height, constant: 0)
           aspectRatioConstraint.identifier = "AspectRatioConstraint"
           aspectRatioConstraint.isActive = true
       
    }
}
