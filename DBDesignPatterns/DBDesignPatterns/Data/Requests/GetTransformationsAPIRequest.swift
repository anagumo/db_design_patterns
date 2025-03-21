import Foundation

struct GetTransformationsAPIRequest: HTTPRequest {
    typealias Response = [TransformationDTO]
    var method: Method = .POST
    var path: String = "/api/heros/tranformations"
    var body: Encodable?
    
    init(hero: Hero?) {
        body = hero.map {
            RequestDTO(id: $0.identifier)
        }
    }
}

extension GetTransformationsAPIRequest {
    struct RequestDTO: Encodable {
        let id: String
    }
}
