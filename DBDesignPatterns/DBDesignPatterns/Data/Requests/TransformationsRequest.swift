import Foundation

struct TransformationsRequest: HTTPRequest {
    typealias Response = [Transformation]
    var method: Method = .POST
    var path: String = "/api/heros/tranformations"
    var headers: [String : String]
    var body: Encodable?
    
    init(hero: Hero) {
        // TODO: Retrive token from KeyChain
        let token = "{jwt}"
        headers = [
            "Authorization": "Bearer \(token)"
        ]
        body = [
            "id": hero.id
        ]
    }
}
