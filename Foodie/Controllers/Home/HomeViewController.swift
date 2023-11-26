
import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    //MARK: - Variables
    
    var ingredients = [Ingredients]()
    let manager = IngredientsServiceManager()
    
    // MARK: - Outlets
    
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycle Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureCollection()
        setUpAnimation()
        ingredients = manager.loadIngredients()!.shuffled()
        
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
    }
    
   

    // MARK: - Methods
    
     func setUpAnimation(){
        animationView.layer.cornerRadius = 15
        animationView.clipsToBounds = true
        animationView.contentMode = .scaleAspectFit
    
    }
    
    func startAnimation(){
        animationView.loopMode = .playOnce
        animationView.play()
    }
    
    func configureCollection(){
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "IngredientsCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "itemCell")

    }
    
    
    func configureTabBar(){
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "fork.knife.circle.fill"), selectedImage: nil)
        
        if let tabBarItem = self.tabBarItem {
            let scaledFont = UIFont.systemFont(ofSize: UIFont.labelFontSize).withSize(12.0)
            tabBarItem.setTitleTextAttributes([.font: scaledFont], for: .normal)
        }
    }
    
    
}




extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! IngredientsCollectionViewCell

        let data = ingredients[indexPath.row]
        cell.configureCell(imageName: data.imageName, itemName: data.name)

       
        return cell
    }


}



extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 89.0)
    }


    
}


extension HomeViewController: UICollectionViewDragDelegate,  UICollectionViewDropDelegate{
    
    
    // MARK: - UICollectionViewDragDelegate

       func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
           let itemProvider = NSItemProvider()
           let dragItem = UIDragItem(itemProvider: itemProvider)
           // You can set additional data to the drag item if needed
           return [dragItem]
       }



    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        // Check if there's at least one item being dropped
        guard let item = coordinator.items.first else {
            return
        }

        // Get the cell being dragged
        if let draggedCell = item.sourceIndexPath,
           let cell = collectionView.cellForItem(at: draggedCell) as? IngredientsCollectionViewCell {

            // Start your animation
            startAnimation()

            // Change color
            cell.ingredientImageView.tintColor = .green
        }
    }


    
}

