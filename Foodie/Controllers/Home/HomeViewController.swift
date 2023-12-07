import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    //MARK: - Variables
    
    var ingredients = [Ingredients]()
    let manager = IngredientsServiceManager()
    var draggedIndexPaths = [IndexPath]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycle Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { self.hideLoadingView() }
        configureTabBar()
        configureCollection()
        setUpAnimation()
        ingredients = manager.loadIngredients()!.shuffled()
    }
    
   

    //MARK: - Animation Setup
    
     func setUpAnimation(){
        animationView.layer.cornerRadius = 15
        animationView.clipsToBounds = true
        animationView.contentMode = .scaleAspectFit
    
    }
    
    //MARK: - Animation Control
    
    func startAnimation(){
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func stopAnimation(){
        animationView.stop()
    }
    
    //MARK: - CollectionView Configuration
    
    func configureCollection(){
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "IngredientsCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "itemCell")

        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
    }
    
    //MARK: - Tab Bar Configuration
    
    func configureTabBar(){
        self.tabBarController?.selectedIndex = 0
        
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "fork.knife.circle.fill"), selectedImage: nil)
        
        if let tabBarItem = self.tabBarItem {
            let scaledFont = UIFont.systemFont(ofSize: UIFont.labelFontSize).withSize(12.0)
            tabBarItem.setTitleTextAttributes([.font: scaledFont], for: .normal)
        }
    }
    
    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! IngredientsCollectionViewCell

        let data = ingredients[indexPath.row]
        cell.configureCell(imageName: data.imageName, itemName: data.name)
        
            // Check if this cell corresponds to a dragged item
        if draggedIndexPaths.contains(indexPath) {
            cell.circleView.layer.borderColor = UIColor.foodieLightGreen.cgColor
            cell.ingredientNameLabel.textColor = .foodieLightGreen
            cell.ingredientImageView.tintColor = .foodieLightGreen
          } else {
              // Reset cell state for non-dragged items
              cell.circleView.layer.borderColor = UIColor.foodieLightBlue.cgColor
              cell.ingredientNameLabel.textColor = .black
              cell.ingredientImageView.tintColor = .black


          }
        
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 89.0)
    }
    
}

// MARK: - UICollectionViewDragDelegate,  UICollectionViewDropDelegate

extension HomeViewController: UICollectionViewDragDelegate,  UICollectionViewDropDelegate{

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = ingredients[indexPath.row]
        let itemProvider = NSItemProvider(object: String(item.id) as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        startAnimation()

        // Set the draggedIndexPath
        draggedIndexPaths.append(indexPath)

        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {

        // Iterate through each draggedIndexPath and update the cells
         for indexPath in draggedIndexPaths {
             if let cell = collectionView.cellForItem(at: indexPath) as? IngredientsCollectionViewCell {
                 stopAnimation()
                 cell.ingredientNameLabel.textColor = .foodieLightGreen
                 cell.circleView.layer.borderColor = UIColor.foodieLightGreen.cgColor
                 cell.ingredientImageView.tintColor = .foodieLightGreen

             }
         }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {

        // Check if there's at least one item being dropped
        guard coordinator.items.first != nil else {
            return
        }
        // Reset draggedIndexPath
        draggedIndexPaths.removeAll()
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

}



// MARK: - Loading View
extension HomeViewController {
    private func showLoadingView() {
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loadingView.tag = 123 // Set a unique tag
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
    }
    
    func hideLoadingView() {
        let loadingViewTag = 123 // Assign a unique tag to your loading view
        if let loadingView = view.viewWithTag(loadingViewTag) {
            loadingView.removeFromSuperview()
        }
    }
}
