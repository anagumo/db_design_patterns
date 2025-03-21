import Foundation

struct LikeHeroAPIRequest: HTTPRequest {
    typealias Response = Data
    var method: Method = .POST
    var path: String = "/api/data/herolike"
    var body: Encodable?
    
    init(identifier: String) {
        body = RequestDTO(hero: identifier)
    }
}

extension LikeHeroAPIRequest {
    struct RequestDTO: Encodable {
        let hero: String
    }
}
