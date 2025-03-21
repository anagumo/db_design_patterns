import Foundation

struct LikeHeroAPIRequest: HTTPRequest {
    typealias Response = Data
    var method: Method = .POST
    var path: String = "/api/data/herolike"
    var body: Encodable?
    
    init(hero: Hero?) {
        body = hero.map {
            RequestDTO(hero: $0.identifier)
        }
    }
}

extension LikeHeroAPIRequest {
    struct RequestDTO: Encodable {
        let hero: String
    }
}
