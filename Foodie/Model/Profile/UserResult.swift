import Foundation


struct UserResult: Decodable {
    var results: [User]
}


// Struct representing "results" key
struct User: Decodable {
    let gender: String
    var name: Name
    var location: Location?
    let email: String
    let login: Login
    var dob: DateOfBirth
    let registered: Registered
    var phone: String
    let cell: String
    let id: ID
    var picture: Picture
    let nat: String
}


// Struct representing "location" key
struct Location: Decodable {
    let street: Street
    var city: String
    let state: String
    let country: String
//    let postcode: String?
    let coordinates: Coordinate
    let timezone: Timezone
}

// Struct representing "street" key

struct Street: Decodable {
    let number: Int
    let name: String
}


// Struct representing "coordinates" key
struct Coordinate: Decodable {
    let latitude: String
    let longitude: String
}

// Struct representing "timezone" key
struct Timezone: Decodable {
    let offset: String
    let description: String
}

// Struct representing "login" key
struct Login: Decodable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

// Struct representing "dob" key
struct DateOfBirth: Decodable {
    var date: String
    let age: Int
}

// Struct representing "registered" key
struct Registered: Decodable {
    let date: String
    let age: Int
}

// Struct representing "id" key
struct ID: Decodable {
    let name: String
    let value: String?
}

// Struct representing "picture" key
struct Picture: Decodable {
    var large: String
    let medium: String
    let thumbnail: String
}

// Struct representing "name" key
struct Name: Decodable {
    let title: String
    var first: String
    let last: String
}


