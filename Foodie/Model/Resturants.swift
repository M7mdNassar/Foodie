//
//  Resturants.swift
//  Foodie
//
//  Created by Mac on 06/11/2023.
//

import Foundation


struct Restaurants: Decodable {
    let name: String
    let isFavorite: Bool
    let imageName: String
}



protocol sendData{
    
    func didFetchData(restaurants:[Restaurants])
    
    
}



class RestaurantApi {
    
    var delegate: sendData?
    func fetchData() {
        if let path = Bundle.main.path(forResource: "RestaurantsData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let restaurants = try JSONDecoder().decode([Restaurants].self, from: data)
                
                delegate?.didFetchData(restaurants: restaurants)
            } catch {
                print("Error loading JSON data: \(error)")
            }
        } else {
            print("JSON file not found in the bundle.")
        }
    }
    
        }
