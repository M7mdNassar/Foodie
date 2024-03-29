

import UIKit

class PostCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var textPostLabel: ExpandableLabel!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundContentView: UIView!
    @IBOutlet weak var commentsContLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var bottomBarView: UIView!
    
    var postImages: [UIImage?] = []
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
         super.awakeFromNib()
         
         collectionView.delegate = self
         collectionView.dataSource = self
         
         // Register your custom cell if needed
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
     }
    
    // MARK: Methods
    
    func configure(userImage:String? , post: Post){
        loadUserImage(from: userImage!)
        self.userNameLabel.text = post.username
    
        self.textPostLabel.text = post.content

        self.commentsContLabel.text = String(post.comments.count)
        self.likesCountLabel.text = String(post.likes)
        
        self.backgroundContentView.layer.cornerRadius = 20
        
        setBottomCorners(for: bottomBarView, cornerRadius: 20.0)
        
        self.postImages = post.images
        self.collectionView.reloadData()

        
    }
    
        
        
        func loadUserImage(from urlString: String) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageURL = URL(string: urlString),
                   let imageData = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: imageData) {
                    
                    DispatchQueue.main.async {
                        self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
                        self.userImageView.image = image
                    }
                }
            }
        }
    
    
    
        
        func setBottomCorners(for view: UIView, cornerRadius: CGFloat) {
             let maskPath = UIBezierPath(
                 roundedRect: view.bounds,
                 byRoundingCorners: [.bottomLeft, .bottomRight],
                 cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
             )

             let maskLayer = CAShapeLayer()
             maskLayer.path = maskPath.cgPath
             view.layer.mask = maskLayer
         }
        
    
    }


extension PostCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell

        
        if let image = postImages[indexPath.item] {
            cell.configure(image: image)
        }
//        else {
//            // Placeholder image or handle the case where the image is nil
//            cell.imageView.image = UIImage(named: "placeholderImage")
//        }

        return cell
    }
}

extension PostCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

