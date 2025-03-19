import Foundation

struct LoginRequest: HTTPRequest {
    typealias Response = String
    let method: Method = .POST
    let path: String = "/api/auth/login"
    var headers: [String : String]
    
    init(username: String, password: String) {
        // Use instead string.data(using: .utf8) to avoid optional
        let loginData = Data(String(format: "%@:%@", username, password).utf8)
        let base64LoginData = loginData.base64EncodedString()
        headers = [
            "Authorization": "Basic \(base64LoginData)"
        ]
    }
}
