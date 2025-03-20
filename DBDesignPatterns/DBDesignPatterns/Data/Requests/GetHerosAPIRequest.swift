import Foundation
import Security

struct GetHerosAPIRequest: HTTPRequest {
    typealias Response = [HeroEntity]
    
    var method: Method = .POST
    var path: String = "/api/heros/all"
    var body: Encodable?
    
    init(name: String = "") {
        body = HeroDTO(name: name)
    }
}

extension GetHerosAPIRequest {
    struct HeroDTO: Encodable {
        let name: String
    }
}
