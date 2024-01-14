
import UIKit

class RestaurantCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    // MARK: - Actions
        
    var favoriteButtonTapped: (() -> Void)?

    
    @IBAction func addToFavourite(_ sender: UIButton) {
        print("Star Clicked")
        favoriteButtonTapped?()
    }
    
    // MARK: - UI Setup Cell
    
    func setUpCell(img: String , name: String , isFavourite: Bool){
        restaurantImage.image = UIImage(named: img)
        restaurantNameLabel.text = NSLocalizedString(name, comment: "")
        setUpFontLabels()
        
        if isFavourite{
            favouriteButton.tintColor = .systemYellow
        }
        else{
            favouriteButton.tintColor = .systemGray3

        }
    }
    
    func setUpFontLabels(){
//        let maximumFontSizeRestaurantName: CGFloat = 50.0
        
        if let customFont = UIFont(name: "Harmattan-Regular", size: 19.0)  {
            restaurantNameLabel.font =  UIFontMetrics.default.scaledFont(for: customFont)
        }
    }
}

