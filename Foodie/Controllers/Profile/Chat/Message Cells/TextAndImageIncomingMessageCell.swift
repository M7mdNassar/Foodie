import UIKit

class TextAndImageIncomingMessageCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var backgroundMessage: UIView!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageImageView: UIImageView!

    // MARK: - Methods
    func configure(messageText: String?, messageImage: UIImage?, userImageUrl: String) {
        self.backgroundColor = .clear
        setupBackground()
        setMessageText(messageText)
        loadUserImage(urlString: userImageUrl)
        setupMessageImage(messageImage)
    }

    private func setupBackground() {
        backgroundMessage.backgroundColor = .foodieLightGreen
        backgroundMessage.layer.cornerRadius = 15.0
        backgroundMessage.layer.masksToBounds = true
    }

    private func setMessageText(_ messageText: String?) {
        if let messageText = messageText {
            messageTextLabel.text = messageText
        }
    }

    private func setupMessageImage(_ messageImage: UIImage?) {
        guard let messageImage = messageImage else { return }

        let dimensions = calculateImageDimensions(for: messageImage)

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

    private func calculateImageDimensions(for image: UIImage) -> (width: CGFloat, height: CGFloat) {
        let maxWidth = UIScreen.main.bounds.width * 0.7
        let minWidth = 150.0

        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let aspectRatio = imageWidth / imageHeight

        let width = min(maxWidth, max(minWidth, imageWidth))
        let height = width / aspectRatio

        return (width, height)
    }
}
