import Foundation


struct UserResult: Codable{
    var results: [User]
}


// Struct representing "results" key
struct User: Codable , Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    let gender: String
    var name: Name
    var location: Location?
    let email: String
//    let login: Login
    var dob: DateOfBirth
//    let registered: Registered
    var phone: String
//    let cell: String
    let id: ID
    var picture: Picture
//    let nat: String
}


// Struct representing "location" key
struct Location: Codable {
//    let street: Street
    var city: String
//    let state: String
//    let country: String
//    let postcode: String?
//    let coordinates: Coordinate
//    let timezone: Timezone
}

// Struct representing "street" key

struct Street: Codable {
    let number: Int
    let name: String
}


// Struct representing "coordinates" key
struct Coordinate: Codable {
    let latitude: String
    let longitude: String
}

// Struct representing "timezone" key
struct Timezone: Codable {
    let offset: String
    let description: String
}

// Struct representing "login" key
struct Login: Codable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

// Struct representing "dob" key
struct DateOfBirth: Codable {
    var date: String
    let age: Int
}

// Struct representing "registered" key
struct Registered: Codable {
    let date: String
    let age: Int
}

// Struct representing "id" key
struct ID: Codable , Equatable{
    let name: String
    let value: String?
}

// Struct representing "picture" key
struct Picture: Codable{
    var large: String
//    let medium: String
//    let thumbnail: String
}

// Struct representing "name" key
struct Name: Codable {
//    let title: String
    var first: String
    let last: String
}
