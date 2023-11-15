import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantCategoryLabel: UILabel!
    @IBOutlet weak var restaurantCollectionView: UICollectionView!
    var restaurantName: String = ""
    var restaurantsImages: [String] = [] // Change the property to an array of strings

    override func awakeFromNib() {
        super.awakeFromNib()
        restaurantCollectionView.delegate = self
        restaurantCollectionView.dataSource = self
    }
    
    func setUpCell(restaurantName: String, restaurantsImages: [String]) {
        self.restaurantCategoryLabel.text = restaurantName
        self.restaurantsImages = restaurantsImages
    }
}

extension RestaurantTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantsImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewRestauranCell", for: indexPath) as! RestaurantCollectionViewCell
        cell.restaurantImageView.image = UIImage(named: restaurantsImages[indexPath.row])
        
        return cell
    }
}

extension RestaurantTableViewCell: UICollectionViewDelegate {
    // Implement any delegate methods if needed
}

extension RestaurantTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.3, height: collectionView.frame.height * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
