
import UIKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imgRestaurant: UIImageView!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func showRestaurantButton(_ sender: UIButton) {
        print("Show Clicked")
    }
    
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        print("Star Clicked")
    }
    
    // MARK: - Setup Cell
    
    func setUpCell(img: String , name: String , isFavourite: Bool){
        imgRestaurant.image = UIImage(named: img)
        labelRestaurantName.text = name
        favouriteButton.isEnabled = isFavourite
    }
    
}
