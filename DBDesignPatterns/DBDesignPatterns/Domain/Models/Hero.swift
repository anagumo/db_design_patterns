import Foundation

/// Represents a domain model
struct Hero: Equatable, Hashable {
    let identifier: String
    let name: String
    let description: String
    let favorite: Bool
    let photo: String
}

extension Hero {
    
    func getFavoriteImage() -> String {
        favorite ? "heart.fill" : "heart"
    }
}
