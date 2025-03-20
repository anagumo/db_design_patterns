import Foundation

struct FavoriteAPIRequest: HTTPRequest {
    typealias Response = Data
    var method: Method = .POST
    var path: String = "/api/data/herolike"
    var body: Encodable?
    
    init(hero: Hero?) {
        body = hero.map {
            FavoriteDTO(hero: $0.identifier)
        }
    }
}

extension FavoriteAPIRequest {
    struct FavoriteDTO: Encodable {
        let hero: String
    }
}
