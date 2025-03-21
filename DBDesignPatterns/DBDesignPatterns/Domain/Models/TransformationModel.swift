import Foundation

/// Represents a domain model
struct TransformationModel: Decodable {
    let name: String
    let description: String
    let photo: String
    let id: String
}
