
import UIKit

class HomeViewController: UIViewController {
 
    
    
    let restaurantApi = RestaurantServiceManager()
    var restaurants:[Restaurant] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = "مطاعم"
        self.navigationItem.backBarButtonItem = backButton
        
        restaurantApi.delegate = self
        tableView.dataSource = self
        restaurantApi.fetchData()
        tableView.delegate = self
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detail = segue.destination as! DetailsViewController
        
        let selectedIndex = tableView.indexPathForSelectedRow?.row
        detail.restaurantImage = restaurants[selectedIndex!].imageName
        detail.restaurantName = restaurants[selectedIndex!].name
        detail.restaurantDescription = restaurants[selectedIndex!].description
        detail.restaurantCity = restaurants[selectedIndex!].city
        detail.latitude = restaurants[selectedIndex!].coordinates.latitude
        detail.longitude = restaurants[selectedIndex!].coordinates.longitude
    }
    
    
    
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeTableViewCell
        let data = restaurants[indexPath.row]
        cell.setUpCell(img: data.imageName, name: data.name , isFavourite:data.isFavorite)
        return cell
    }
    
    
}

extension HomeViewController: sendData{
    func didFetchData(restaurants: [Restaurant]) {
        self.restaurants = restaurants
        tableView.reloadData()
    }
    
    
    
 
    
    
    
}
extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
}
