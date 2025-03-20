/// Represents an API entity
struct HeroEntity: Decodable {
    let identifier: String
    let name: String
    let description: String
    let favorite: Bool
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case description
        case favorite
        case photo
    }
}
