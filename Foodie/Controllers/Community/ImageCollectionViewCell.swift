
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Methods
    func configure(imageUrl: String) {
        self.imageView.layer.cornerRadius = 20
        self.imageView.layer.masksToBounds = true
        
        
        if imageUrl != ""{
            self.imageView.sd_setImage(with: URL(string: imageUrl))
           
        }
       
        
    }
    
    
    func load(from urlString: String) {
        
        DispatchQueue.global().async { [weak self] in
            if let imageURL = URL(string: urlString),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {

                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }

}
