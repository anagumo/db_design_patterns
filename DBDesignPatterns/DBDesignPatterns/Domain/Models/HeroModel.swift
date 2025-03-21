import Foundation

/// Represents a domain model
struct HeroModel: Equatable, Hashable {
    let identifier: String
    let name: String
    let description: String
    var favorite: Bool
    let photo: String
}

extension HeroModel {
    
    func getFavoriteImage() -> String {
        favorite ? "heart.fill" : "heart"
    }
}
