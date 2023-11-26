
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
    
    func setUpFontLabels() {
        let maximumFontSizeRestaurantName: CGFloat = 37
        let desiredFontSize: CGFloat = 17.0

        if let customFont = UIFont(name: "Harmattan-Regular", size: desiredFontSize) {
            let scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
            let finalFontSize = min(scaledFont.pointSize, maximumFontSizeRestaurantName)
            restaurantNameLabel.font = scaledFont.withSize(finalFontSize)
        }
    }

    

}



