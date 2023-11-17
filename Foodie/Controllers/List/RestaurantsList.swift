import UIKit

class RestaurantsList: UIViewController {

    // MARK: - Properties
    
    let restaurantManager = RestaurantServiceManager()
    var restaurants: [Restaurant] = []
    let backButton = UIBarButtonItem()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setUpTableView()
        fetchRestaurantData()
 
    }

    // MARK: - Actions

    @IBAction func favoriteSwitchChanged(_ sender: UISwitch) {
        updateDisplayedRestaurants(isFavorite: sender.isOn)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail", let selectedIndex = tableView.indexPathForSelectedRow?.row {
            let detail = segue.destination as! RestaurantDetails
            detail.restaurant = restaurants[selectedIndex]
        }
    }
    
}

// MARK: - TableView Data Source

extension RestaurantsList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! RestaurantCell
        let data = restaurants[indexPath.row]
        cell.setUpCell(img: data.imageName, name: data.name, isFavourite: data.isFavorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! RestaurantCell
        let data = restaurants[indexPath.row]
        cell.setUpCell(img: data.imageName, name: data.name, isFavourite: data.isFavorite)

        // Calculate the height required for the restaurantNameLabel
        let labelSize = cell.restaurantNameLabel.sizeThatFits(CGSize(width: cell.restaurantNameLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))

        // Set the cell height as the maximum between label height and 120
        return max(labelSize.height, 100)
    }

}


// MARK: - TableView Delegate

extension RestaurantsList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)  // for remove the highlight of selected cell
    }
}

// MARK: - Private Methods

private extension RestaurantsList {
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchRestaurantData() {
        restaurantManager.fetchData { [weak self] restaurants in
            self?.restaurants = restaurants
            self?.tableView.reloadData()
        }
    }
        func updateDisplayedRestaurants(isFavorite: Bool) {
            if isFavorite {
                restaurantManager.getFavoriteRestaurants { [weak self] favoriteRestaurants in
                    self?.restaurants = favoriteRestaurants
                    self?.tableView.reloadData()
                }
            } else {
                restaurantManager.getAllRestaurants { [weak self] allRestaurants in
                    self?.restaurants = allRestaurants
                    self?.tableView.reloadData()
                }
            }
        }
    
    func configureNavigationBar(){
        backButton.title = "مطاعم"
        self.navigationItem.backBarButtonItem = backButton
    }
    
    
    }

