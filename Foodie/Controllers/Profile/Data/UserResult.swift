import Foundation


struct UserResult: Decodable {
    let results: [User]
    let info: Info
}


// Struct representing "results" key
struct User: Decodable {
    let gender: String
    let name: Name
    let location: Location?
    let email: String
    let login: Login
    let dob: DateOfBirth
    let registered: Registered
    let phone: String
    let cell: String
    let id: ID
    let picture: Picture
    let nat: String
}



// Struct representing "location" key
struct Location: Decodable {
    let street: Street
    let city: String
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
    let date: String
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
    let large: String
    let medium: String
    let thumbnail: String
}

// Struct representing "name" key
struct Name: Decodable {
    let title: String
    let first: String
    let last: String
}


// Struct representing "info" key
struct Info: Decodable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}

