import UIKit

class ImageOutgoingMessageCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!

    // MARK: Methods

    func configure(messageImage: UIImage?, userImageUrl: String) {
        self.backgroundColor = .clear
        guard let messageImage = messageImage else { return }

        setupMessageImageView(with: messageImage)
        loadUserImage(from: userImageUrl)
    }

    private func setupMessageImageView(with image: UIImage) {
        messageImageView.layer.cornerRadius = 15.0
        messageImageView.layer.masksToBounds = true

        let dimensions = image.calculateImageDimensions(maxWidth: UIScreen.main.bounds.width * 0.7, minWidth: 150.0)
        updateImageViewConstraints(with: dimensions)
        
        messageImageView.image = image
        updateContentMode(for: dimensions)
    }

    private func updateImageViewConstraints(with dimensions: (width: CGFloat, height: CGFloat)) {
        messageImageView.widthAnchor.constraint(equalToConstant: dimensions.width).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: dimensions.height).isActive = true
        updateAspectRatioConstraint(with: dimensions)
    }

    private func updateContentMode(for dimensions: (width: CGFloat, height: CGFloat)) {
        if dimensions.width > dimensions.height {
            messageImageView.contentMode = .scaleAspectFill // Landscape
        } else {
            messageImageView.contentMode = .scaleAspectFit // Portrait
        }
    }

    private func updateAspectRatioConstraint(with dimensions: (width: CGFloat, height: CGFloat)) {
        for constraint in messageImageView.constraints {
            if constraint.firstAttribute == .width && constraint.secondAttribute == .height {
                constraint.isActive = false // deactivate existing constraint
                let aspectRatioConstraint = messageImageView.widthAnchor.constraint(equalTo: messageImageView.heightAnchor, multiplier: dimensions.width / dimensions.height)
                aspectRatioConstraint.isActive = true
            }
        }
    }

    private func loadUserImage(from urlString: String) {
        userImageView.load(from: urlString)
    }
}
