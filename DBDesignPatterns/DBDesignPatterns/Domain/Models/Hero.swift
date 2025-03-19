import Foundation

/// Represents a domain model
struct Hero: Decodable {
    let id: String
    let name: String
    let description: String
    let favorite: Bool
    let photo: String
}
