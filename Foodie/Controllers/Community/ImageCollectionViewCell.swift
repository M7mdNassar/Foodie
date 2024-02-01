
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Methods
    func configure(imageUrl: String) {
        self.imageView.layer.cornerRadius = 20
        self.imageView.layer.masksToBounds = true

        guard let url = URL(string: imageUrl) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
            }
        }.resume()
    }

}
