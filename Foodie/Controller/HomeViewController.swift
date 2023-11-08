import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    
    let restaurantManager = RestaurantServiceManager()
    var restaurants: [Restaurant] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem()
        backButton.title = "مطاعم"
        self.navigationItem.backBarButtonItem = backButton

        setUpTableView()
        fetchRestaurantData()
    }

    // MARK: - Actions

    @IBAction func favoriteSwitchChanged(_ sender: UISwitch) {
        updateDisplayedRestaurants(isFavorite: sender.isOn)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail", let selectedIndex = tableView.indexPathForSelectedRow?.row {
            let detail = segue.destination as! DetailsViewController
            detail.restaurant = restaurants[selectedIndex]
        }
    }
}

// MARK: - TableView Data Source

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        let data = restaurants[indexPath.row]
        cell.setUpCell(img: data.imageName, name: data.name, isFavourite: data.isFavorite)
        return cell
    }
}

// MARK: - Data Fetching Delegate

extension HomeViewController: sendData {
    func didFetchData(restaurants: [Restaurant]) {
        self.restaurants = restaurants
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
}

// MARK: - Private Methods

private extension HomeViewController {
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    func fetchRestaurantData() {
        restaurantManager.delegate = self
        restaurantManager.fetchData()
    }

    func updateDisplayedRestaurants(isFavorite: Bool) {
        if isFavorite {
            restaurants = restaurantManager.getFavoriteRestaurants()
        } else {
            restaurants = restaurantManager.getAllRestaurants()
        }
        tableView.reloadData()
    }
}
