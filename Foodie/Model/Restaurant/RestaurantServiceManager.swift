import Foundation

class RestaurantServiceManager {

    // MARK: - Properties

    private var allRestaurants: [Restaurant] = []
    private var favoriteRestaurants: [Restaurant] = []

    // MARK: - Data Fetching

    func fetchData() -> [Restaurant]? {
        if let path = Bundle.main.url(forResource: "RestaurantsData", withExtension:"json") , let data = try? Data(contentsOf: path){
            do {
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                allRestaurants = restaurants
                favoriteRestaurants = restaurants.filter { $0.isFavorite }
                return allRestaurants
            }
            catch {
                print("Error decoding JSON: \(error)")
                return nil
           }
            
        }
        return nil
        }
    

    // MARK: - Getter Methods

    func getFavoriteRestaurants() -> [Restaurant] {
        return favoriteRestaurants
    }

    func getAllRestaurants() -> [Restaurant] {
        return allRestaurants
    }
}


