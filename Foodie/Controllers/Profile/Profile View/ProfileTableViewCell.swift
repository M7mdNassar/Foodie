
import UIKit

class ProfileTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var optionTitleLabel: UILabel!
    @IBOutlet weak var optionIconImageView: UIImageView!
    
    // MARK: - Set Up Cell
    
    func setUpCell(optionTitle: String, optionIcon: UIImage ){
        self.optionIconImageView.image = optionIcon
        self.optionTitleLabel.text = optionTitle
        self.setUpFont()
    }
    
    func setUpFont(){
       //let maximumFontSizeRestaurantName: CGFloat = 50.0
        
        if let customFont = UIFont(name: "Harmattan-Regular", size: 19.0)  {
            optionTitleLabel.font =  UIFontMetrics.default.scaledFont(for: customFont)
        }
    }
}
