
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
        if let customFont = UIFont(name: "NotoKufiArabic-Regular", size: 17.0) {
            let scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
            restaurantNameLabel.font = scaledFont.withSize(scaledFont.pointSize)
        }
    }

}



