import UIKit

class TextAndImageIncomingMessageCell: UITableViewCell {

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
        userImageView.load(from: userImageUrl)
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

        let dimensions = messageImage.calculateImageDimensions(maxWidth: UIScreen.main.bounds.width * 0.7, minWidth: 150.0)

        messageImageView.widthAnchor.constraint(equalToConstant: dimensions.width).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: dimensions.height).isActive = true

        messageImageView.image = messageImage
        messageImageView.layer.cornerRadius = 15.0
        messageImageView.layer.masksToBounds = true

        let aspectRatio = dimensions.width / dimensions.height

        if dimensions.width > dimensions.height {
            messageImageView.contentMode = .scaleAspectFill
        } else {
            messageImageView.contentMode = .scaleAspectFit
        }

        for constraint in messageImageView.constraints {
            if constraint.firstAttribute == .width && constraint.secondAttribute == .height {
                constraint.isActive = false
                let aspectRatioConstraint = messageImageView.widthAnchor.constraint(equalTo: messageImageView.heightAnchor, multiplier: aspectRatio)
                aspectRatioConstraint.isActive = true
            }
        }
    }
}
