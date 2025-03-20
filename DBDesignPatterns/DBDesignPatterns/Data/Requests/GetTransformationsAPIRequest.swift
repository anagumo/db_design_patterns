import Foundation

struct GetTransformationsAPIRequest: HTTPRequest {
    typealias Response = [TransformationEntity]
    var method: Method = .POST
    var path: String = "/api/heros/tranformations"
    var body: Encodable?
    
    init(hero: Hero?) {
        body = hero.map {
            TransformationDTO(id: $0.identifier)
        }
    }
}

extension GetTransformationsAPIRequest {
    struct TransformationDTO: Encodable {
        let id: String
    }
}
