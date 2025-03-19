import Foundation
import OSLog

protocol HTTPRequest {
    // To set a external associated type to this http request
    associatedtype Response: Decodable
    // An alias for completion result
    typealias APIRequestResult = Result<Response, APIErrorResponse>
    // An alias for clossure completion
    typealias APIRequestCompletion = (APIRequestResult) -> Void
    
    var host: String { get }
    var method: Method { get }
    var path: String { get }
    var queryParameters: [String:String] { get }
    var headers: [String:String] { get }
    var body: Encodable? { get }
}

extension HTTPRequest {
    // Set default values for methods such as GET
    var host: String { "dragonball.keepcoding.education" }
    var queryParameters: [String: String] { [:] }
    var headers: [String:String] { [:] }
    var body: Encodable? { nil }
    
    func getRequest() throws -> URLRequest {
        // Create the url components
        var urlComponentns = URLComponents()
        urlComponentns.scheme = "https"
        urlComponentns.host = host
        urlComponentns.path = path
        
        if !queryParameters.isEmpty {
            urlComponentns.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        guard let url = urlComponentns.url else {
            Logger.debug.error("Malformed URL")
            // TODO: Replace this error
            fatalError("Malformed url")
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body, method != .GET {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        request.timeoutInterval = 30
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ].merging(headers) { $1 }
        
        return request
    }
    
    func perform(apiSession: APISession = .shared, completion: @escaping APIRequestCompletion) {
        apiSession.request(apiRequest: self) { result in
            do {
                let data = try result.get()
                if Response.self == Void.self {
                    completion(.success(() as! Response))
                } else if Response.self == Data.self {
                    completion(.success(data as! Response))
                } else if Response.self == String.self {
                    // Since JSONDecoder does not support plain strings is necessary add this validation for jwt case
                    let decodedString = String(data: data, encoding: .utf8)
                    return completion(.success(decodedString as! Response))
                } else {
                    let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                    return completion(.success(decodedResponse))
                }
            } catch let error as APIErrorResponse {
                completion(.failure(error))
            } catch let error as DecodingError {
                completion(.failure(APIErrorResponse.parseData(path)))
            } catch {
                completion(.failure(APIErrorResponse.unknown(path)))
            }
        }
    }
}
