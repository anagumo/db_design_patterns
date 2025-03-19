import Foundation
import Security

struct HerosRequest: HTTPRequest {
    typealias Response = [Hero]
    
    var method: Method = .POST
    var path: String = "/api/heros/all"
    var headers: [String : String]
    var body: Encodable?
    
    init(name: String = "") {
        // TODO: Retrive token from KeyChain
        let token = "{jwt}"
        headers = [
            "Authorization": "Bearer \(token)"
        ]
        body = [
            "name": name
        ]
    }
}
