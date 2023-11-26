
import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantCityLabel: UILabel!
    
     // MARK: - Configure cell content
    
    func setUpCell(img: String , name: String , city: String){
        restaurantImageView.image = UIImage(named: img)
        restaurantNameLabel.text = NSLocalizedString(name, comment: "")
        restaurantCityLabel.text = NSLocalizedString(city, comment: "")
        setUpFontLabels()
    }
    
    // MARK: - Set up font styles

    func setUpFontLabels() {
        let maximumFontSizeRestaurantName: CGFloat = 60.0
        let maximumFontSizeRestaurantCity: CGFloat = 50.0
        if let customFont = UIFont(name: "Harmattan-Regular", size: 30.0) {
            let scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
            restaurantNameLabel.font = scaledFont.withSize(min(scaledFont.pointSize, maximumFontSizeRestaurantName))
        }
        
        if let customFont = UIFont(name: "Harmattan-Regular", size: 17.0) {
            let scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
            restaurantCityLabel.font = scaledFont.withSize(min(scaledFont.pointSize, maximumFontSizeRestaurantCity))
        }
    }
    
}



