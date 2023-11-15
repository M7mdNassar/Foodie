
import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantCityLabel: UILabel!
    
     // MARK: - Configure cell content
    func setUpCell(img: String , name: String , city: String){
        restaurantImageView.image = UIImage(named: img)
        restaurantNameLabel.text = name
        restaurantCityLabel.text = city
        setUpFontLabels()
    }
    
    // MARK: - Set up font styles
    func setUpFontLabels(){
        restaurantNameLabel.font = UIFont(name: "NotoKufiArabic-Regular_Bold", size: 30.0)
        restaurantCityLabel.font = UIFont(name: "NotoKufiArabic-Regular", size: 17.0)
        
    }
    
}
