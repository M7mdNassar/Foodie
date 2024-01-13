

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Methods
    
    func configure(image: UIImage){
        
        self.imageView.layer.cornerRadius = 20
        self.imageView.layer.masksToBounds = true
             
        self.imageView.image = image
        
    }

    
   
     
 
}
