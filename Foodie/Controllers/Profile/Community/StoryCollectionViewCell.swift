
import UIKit

class StoryCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    func configure(userName: String , storyImage: UIImage){
        self.userNameLabel.text = userName
        
        
        self.storyImageView.layer.cornerRadius = self.storyImageView.frame.size.width / 2
        self.storyImageView.layer.borderWidth = 1.0
        self.storyImageView.layer.borderColor = UIColor.blue.cgColor
        self.storyImageView.clipsToBounds = true
        
        self.storyImageView.image = storyImage
        
        
    }
    
    
    
    
}
