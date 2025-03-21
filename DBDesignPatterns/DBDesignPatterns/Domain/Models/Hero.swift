import Foundation

/// Represents a domain model
struct Hero: Equatable {
    let identifier: String
    let name: String
    let description: String
    let favorite: Bool
    let photo: String
}
