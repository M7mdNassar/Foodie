
import Foundation

class RestaurantServiceManager {

    // MARK: - Properties

    private var allRestaurants: [Restaurant] = []
    private var favoriteRestaurants: [Restaurant] = []

    // MARK: - Data Fetching

    func fetchData(completion: @escaping ([Restaurant]) -> Void) {
        if let path = Bundle.main.path(forResource: "RestaurantsData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)

                allRestaurants = restaurants
                favoriteRestaurants = restaurants.filter { $0.isFavorite }
                completion(allRestaurants)
            } catch {
                print("Error loading JSON data: \(error)")
                completion([])
            }
        } else {
            print("JSON file not found in the bundle.")
            completion([])
        }
    }

    // MARK: - Getter Methods

    func getFavoriteRestaurants(completion: @escaping ([Restaurant]) -> Void) {
        completion(favoriteRestaurants)
    }

    func getAllRestaurants(completion: @escaping ([Restaurant]) -> Void) {
        completion(allRestaurants)
    }
}
