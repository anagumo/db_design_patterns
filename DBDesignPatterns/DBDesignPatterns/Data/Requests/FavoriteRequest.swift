import Foundation

struct FavoriteRequest: HTTPRequest {
    typealias Response = Data
    var method: Method = .POST
    var path: String = "/api/data/herolike"
    var headers: [String : String]
    var body: Encodable?
    
    init(hero: Hero) {
        // TODO: Retrive token from KeyChain
        let token = "{jwt}"
        headers = [
            "Authorization": "Bearer \(token)"
        ]
        body = [
            "hero": hero.id
        ]
    }
}
