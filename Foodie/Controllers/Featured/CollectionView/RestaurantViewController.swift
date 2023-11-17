import UIKit

class RestaurantViewController: UIViewController {
    
    // MARK: - Properties
    
    let restaurantManager = RestaurantServiceManager()
    var restaurantData: [Restaurant] = []
    var restaurantSections: [RestaurantCategory: [Restaurant]] = [:]
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        fetchRestaurantData()
        categoriseData()
    }
    
}
    // MARK: - Enum Definition

enum RestaurantCategory: String, CaseIterable {
    case Mountains = "Mountains"
    case Rivers = "Rivers"
}

    // MARK: - UITableViewDelegate

extension RestaurantViewController: UITableViewDelegate{
    
}
    // MARK: - UITableViewDataSource

extension RestaurantViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restaurantSections.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tabelViewCell") as! RestaurantTableViewCell

        let category = RestaurantCategory.allCases[indexPath.row]

        if let restaurants = restaurantSections[category] {
            let images = restaurants.map {$0.imageName} // I need store the all images with specific category
            let names = restaurants.map {$0.name} // Also names
            cell.setUpCell(title: category.rawValue, images: images, names: names)
        }

        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tabelViewCell") as! RestaurantTableViewCell

        let category = RestaurantCategory.allCases[indexPath.row]
        var images = [String]()
        var names = [String]()
        if let restaurants = restaurantSections[category] {
            images = restaurants.map {$0.imageName}
            names = restaurants.map {$0.name}
            cell.setUpCell(title: category.rawValue, images: images, names: names)
        }

        let categoryLabelSize = cell.restaurantCategoryLabel.sizeThatFits(CGSize(width: cell.restaurantCategoryLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))

        // Dequeue a cell from the collectionView, not the tableView
        let cell2 = cell.collectionView.dequeueReusableCell(withReuseIdentifier: "RCell", for: indexPath) as! RestaurantCollectionViewCell
        cell2.configureCell(imageName: images[indexPath.row], name: names[indexPath.row])


        let restaurantNameLabelSize = cell2.restaurantNameLabel.sizeThatFits(CGSize(width: cell2.restaurantNameLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let restaurantImageSize = cell2.restaurantImageView.sizeThatFits(CGSize(width: cell2.restaurantImageView.frame.width, height: CGFloat.greatestFiniteMagnitude))


        return categoryLabelSize.height + restaurantNameLabelSize.height +         restaurantImageSize.height/5
    }
 
}

    // MARK: - Private Methods

private extension RestaurantViewController {
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchRestaurantData() {
        restaurantManager.fetchData { [weak self] restaurants in
            self?.restaurantData = restaurants
        }
    }
    
    
    func categoriseData(){
        for category in RestaurantCategory.allCases {
               let restaurantsInCategory = restaurantData.filter { $0.category == category.rawValue }
               restaurantSections[category] = restaurantsInCategory
           }
    }
    
}
