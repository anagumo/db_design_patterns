import Foundation
import Security

struct GetHerosAPIRequest: HTTPRequest {
    typealias Response = [HeroDTO]
    
    var method: Method = .POST
    var path: String = "/api/heros/all"
    var body: Encodable?
    
    init(name: String = "") {
        body = RequestDTO(name: name)
    }
}

extension GetHerosAPIRequest {
    struct RequestDTO: Encodable {
        let name: String
    }
}
