import Foundation

struct MarkHeroAsFavoriteAPIRequest: HTTPRequest {
    typealias Response = Data
    var method: Method = .POST
    var path: String = "/api/data/herolike"
    var body: Encodable?
    
    init(identifier: String) {
        body = RequestDTO(hero: identifier)
    }
}

extension MarkHeroAsFavoriteAPIRequest {
    struct RequestDTO: Encodable {
        let hero: String
    }
}
