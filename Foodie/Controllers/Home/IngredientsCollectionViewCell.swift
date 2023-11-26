import UIKit

class IngredientsCollectionViewCell: UICollectionViewCell {

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

    func setUpImage(_ image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        image.backgroundColor = UIColor.foodieLightGreenBlue
        image.layer.borderWidth = 2.0
        image.layer.borderColor = UIColor.foodieLightBlue.cgColor
    }

    // Reset cell background color
    func resetCellBackgroundColor() {
        ingredientImageView.backgroundColor = UIColor.foodieLightGreenBlue
    }
}
