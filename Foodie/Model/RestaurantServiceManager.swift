

import Foundation

protocol sendData {
    
    func didFetchData(restaurants:[Restaurant])
    
    
}


class RestaurantServiceManager {
    
    var delegate: sendData?
    func fetchData() {
        if let path = Bundle.main.path(forResource: "RestaurantsData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                
                delegate?.didFetchData(restaurants: restaurants)
            } catch {
                print("Error loading JSON data: \(error)")
            }
        } else {
            print("JSON file not found in the bundle.")
        }
    }
    
        }
