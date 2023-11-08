
import Foundation


protocol sendData {
    func didFetchData(restaurants: [Restaurant])
}

class RestaurantServiceManager {
    
    // MARK: - Properties
    
    var delegate: sendData?
    private var allRestaurants: [Restaurant] = []
    private var favoriteRestaurants: [Restaurant] = []

    // MARK: - Data Fetching
    
    func fetchData() {
        if let path = Bundle.main.path(forResource: "RestaurantsData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)

                allRestaurants = restaurants
                favoriteRestaurants = restaurants.filter { $0.isFavorite }
                delegate?.didFetchData(restaurants: allRestaurants)
                
            } catch {
                print("Error loading JSON data: \(error)")
            }
        } else {
            print("JSON file not found in the bundle.")
        }
    }
    
    // MARK: - Getter Methods

    func getFavoriteRestaurants() -> [Restaurant] {
        return favoriteRestaurants
    }
    
    func getAllRestaurants() -> [Restaurant] {
        return allRestaurants
    }
}
