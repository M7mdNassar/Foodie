import UIKit

class IngredientsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Cell Configuration
    func configureCell(imageName: String, itemName: String) {
        setUpCircleView()
        ingredientImageView.image = UIImage(named: imageName)
        ingredientNameLabel.text = NSLocalizedString(itemName, comment: "")
    }
    
    // MARK: - SetUp Cell
    
    func setUpCircleView() {
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.clipsToBounds = true
        circleView.backgroundColor = UIColor.foodieLightGreenBlue
        circleView.layer.borderWidth = 2.0
        circleView.layer.borderColor = UIColor.foodieLightBlue.cgColor
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()

         // Reset any state that might be changed during usage
        self.ingredientImageView.layer.borderColor = UIColor.foodieLightBlue.cgColor
        self.ingredientNameLabel.textColor = .black
        self.ingredientImageView.tintColor = .black

        
     }
    
}
