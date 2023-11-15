
import UIKit

class RestaurantCollectionViewCell: UICollectionViewCell {
    
      // MARK: - Outlets
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
    }

      // MARK: - Cell Configration
    
    func configureCell(imageName: String, name: String) {
           restaurantImageView.image = UIImage(named: imageName)
           restaurantImageView.layer.cornerRadius = 10
           restaurantImageView.layer.masksToBounds = true
           restaurantNameLabel.text = name
           setUpFontLabels()
       }
    
    func setUpFontLabels(){
        restaurantNameLabel.font = UIFont(name: "NotoKufiArabic-Regular", size: 17.0)
    }
}


