
import Foundation

struct Restaurant: Decodable {
    var name: String
    var isFavorite: Bool
    var imageName: String
    var coordinates: Coordinates
    var description: String
    var city: String
}

struct Coordinates: Decodable {
    var longitude: Double
    var latitude: Double
}

