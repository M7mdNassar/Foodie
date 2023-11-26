import UIKit

class IngredientsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var ingredientNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Cell Configuration
    func configureCell(imageName: String, itemName: String) {
        setUpImage(ingredientImageView)
        ingredientImageView.image = UIImage(named: imageName)
        ingredientNameLabel.text = NSLocalizedString(itemName, comment: "")
    }
    
    // MARK: - SetUp Cell
    
    func setUpImage(_ image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        image.backgroundColor = UIColor.foodieLightGreenBlue
        image.layer.borderWidth = 2.0
        image.layer.borderColor = UIColor.foodieLightBlue.cgColor
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()

         // Reset any state that might be changed during usage
        self.ingredientImageView.layer.borderColor = UIColor.foodieLightBlue.cgColor
        self.ingredientNameLabel.textColor = .black
        
     }
    
}
