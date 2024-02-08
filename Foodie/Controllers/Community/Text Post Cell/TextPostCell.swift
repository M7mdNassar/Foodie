
import UIKit

class TextPostCell: UITableViewCell {

    
    // MARK: Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var textPostLabel: ExpandableLabel!
    @IBOutlet weak var backgroundContentView: UIView!
    @IBOutlet weak var commentsContLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    
    // MARK: Variables
    
    var likes: Int = 0

    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: Actions
    
    
    @IBAction func makeLike(_ sender: UIButton) {
        
        if self.likeButton.tintColor == .white{
            likes += 1
            self.likesCountLabel.text = String(likes)
            self.likeButton.tintColor = .red
            
        }else{
            likes -= 1
            self.likesCountLabel.text = String(likes)
            self.likeButton.tintColor = .white
        }
    }
    
    // MARK: Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset label's content
        textPostLabel.text = nil
        
        // Remove the "Read more" button if it's added
        removeReadMoreButtonIfNeeded()
    }
    
    private func removeReadMoreButtonIfNeeded() {
        // Find and remove the "Read more" button if it's added
        if let readMoreButton = self.contentView.viewWithTag(9090) {
            readMoreButton.removeFromSuperview()
        }
    }


    func configure(post : Post){
        if post.userImageUrl != ""{
            self.userImageView.sd_setImage(with: URL(string: post.userImageUrl!))
            
            
            
            self.userImageView.layer.cornerRadius = self.userImageView.frame.height/2
            self.userImageView.clipsToBounds = true
        }
        self.userNameLabel.text = post.userName
        self.textPostLabel.text = post.content

        
        self.commentsContLabel.text = String(post.comments.count)
        
        self.likesCountLabel.text = String(post.likes)
        self.likes = post.likes
        
        self.backgroundContentView.layer.cornerRadius = 20
        
        setBottomCorners(for: bottomBarView, cornerRadius: 20.0)
        
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
