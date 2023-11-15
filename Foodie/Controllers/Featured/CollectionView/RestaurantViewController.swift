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
        return 250
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
