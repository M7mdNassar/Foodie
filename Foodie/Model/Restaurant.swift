
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

