
import UIKit

class StoryCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    func configure(userName: String , storyImage: UIImage){
        self.userNameLabel.text = userName
        
        
        self.borderView.layer.cornerRadius = self.borderView.frame.size.width / 2
        self.storyImageView.layer.cornerRadius = self.storyImageView.frame.size.width / 2
        self.storyImageView.layer.borderWidth = 2
        self.storyImageView.layer.borderColor = UIColor.white.cgColor
        self.storyImageView.clipsToBounds = true
        
        self.storyImageView.image = storyImage
        
        
    }
    
    
    
    
}
