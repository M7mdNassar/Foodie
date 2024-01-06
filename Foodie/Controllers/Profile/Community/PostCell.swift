

import UIKit

class PostCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var textPostLabel: ExpandableLabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var backgroundContentView: UIView!
    @IBOutlet weak var commentsContLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var bottomBarView: UIView!
    
    

    func configure(userImage:String? , post: Post){
        loadUserImage(from: userImage!)
        self.userNameLabel.text = post.username
    
    
        self.textPostLabel.text = post.content
   

        
        self.commentsContLabel.text = String(post.comments.count)
        self.likesCountLabel.text = String(post.likes)
        
        self.backgroundContentView.layer.cornerRadius = 20
        
        setBottomCorners(for: bottomBarView, cornerRadius: 20.0)
        
        
        self.postImageView.layer.cornerRadius = 20
        self.postImageView.layer.masksToBounds = true
        
        
        if let image = post.images{
            
            // Calculate image dimensions
            let dimensions = calculateImageDimensions(for: image)
            
            // Update image view frame constraints
            self.postImageView.widthAnchor.constraint(equalToConstant: dimensions.width).isActive = true
            self.postImageView.heightAnchor.constraint(equalToConstant: dimensions.height).isActive = true
            
            // Set image and content mode
            self.postImageView.image = post.images
            
            // Calculate aspect ratio
            let aspectRatio = dimensions.width / dimensions.height
            
            if dimensions.width > dimensions.height {
                self.postImageView.contentMode = .scaleAspectFill // Landscape
            } else {
                self.postImageView.contentMode = .scaleAspectFit // Portrait
            }
            
            // Update aspect ratio constraint
            for constraint in self.postImageView.constraints {
                if constraint.firstAttribute == .width && constraint.secondAttribute == .height {
                    // Assuming you have only one aspect ratio constraint
                    constraint.isActive = false // deactivate existing constraint
                    let aspectRatioConstraint = self.postImageView.widthAnchor.constraint(equalTo: self.postImageView.heightAnchor, multiplier: aspectRatio)
                    aspectRatioConstraint.isActive = true
                }
                
                
            }
            
        }
        else {
            self.postImageView.image = nil

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
        
        func setBottomCorners(for view: UIView, cornerRadius: CGFloat) {
             let maskPath = UIBezierPath(
                 roundedRect: view.bounds,
                 byRoundingCorners: [.bottomLeft, .bottomRight],
                 cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
             )

             let maskLayer = CAShapeLayer()
             maskLayer.path = maskPath.cgPath
             view.layer.mask = maskLayer
         }
        
    
    }
