//
//  Restaurant.swift
//  Foodie
//
//  Created by Mac on 05/11/2023.
//

import Foundation

struct Restaurant: Decodable {
    let name: String
    let isFavorite: Bool
    let imageName: String
    let coordinates: Coordinates
    let description: String
    let city: String
}

struct Coordinates: Decodable {
    let longitude: Double
    let latitude: Double
}



protocol sendData {
    
    func didFetchData(restaurants:[Restaurant])
    
    
}



class RestaurantApi {
    
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
