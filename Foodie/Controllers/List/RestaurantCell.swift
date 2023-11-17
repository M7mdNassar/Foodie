
import UIKit

class RestaurantCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func showRestaurantButton(_ sender: UIButton) {
        print("Show Clicked")
    }
    
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        print("Star Clicked")
    }
    
    // MARK: - UI Setup Cell
    
    func setUpCell(img: String , name: String , isFavourite: Bool){
        restaurantImage.image = UIImage(named: img)
        restaurantNameLabel.text = name
        setUpFontLabels()
        favouriteButton.isEnabled = isFavourite
    }
    
    func setUpFontLabels(){
//        let maximumFontSizeRestaurantName: CGFloat = 50.0
        
        if let customFont = UIFont(name: "NotoKufiArabic-Regular", size: 19.0)  {
            restaurantNameLabel.font =  UIFontMetrics.default.scaledFont(for: customFont)
        }
    }
}

