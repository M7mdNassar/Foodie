
import UIKit

class RestaurantTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var restaurantCategoryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var title = " "
    var images = [String]()
    var names = [String]()
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCollectionView()
        setUpFontLabels()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Cell Configuration
    
    func setUpCell(title: String , images:[String] , names:[String]){
        self.restaurantCategoryLabel.text = title
        self.images = images
        self.names = names
    }
    
    func setUpFontLabels(){
        let maximumFontSizeRestaurantCategory: CGFloat = 50.0
        if let customFont = UIFont(name: "NotoKufiArabic-Regular", size: 15.0) {
            let scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
            restaurantCategoryLabel.font = scaledFont.withSize(min(scaledFont.pointSize, maximumFontSizeRestaurantCategory))
        }
    }

    // MARK: - Collection View Configuration
     
     private func configureCollectionView() {
         collectionView.delegate = self
         collectionView.dataSource = self
         let nib = UINib(nibName: "RestaurantCollectionViewCell", bundle: nil)
         collectionView.register(nib, forCellWithReuseIdentifier: "RCell")
     }

}


   // MARK: - UICollectionViewDataSource

extension RestaurantTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RCell", for: indexPath) as! RestaurantCollectionViewCell
        cell.configureCell(imageName: images[indexPath.row], name: names[indexPath.row])

        return cell
    }
    
    
    
}


extension RestaurantTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.5 , height: collectionView.frame.height)
    }
    


}
