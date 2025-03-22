import Foundation

protocol APISessionContract {
    /// Implements a request using a session of URLSession
    /// - Parameters:
    ///   - apiRequest: an object of type `(URLRequest)` that represents a request to the server and contains an URL, headers and methods such as GET
    ///   - completion: a clossure of type `(Result<Data, Error>) -> ())`  that represents the data result and returns either data or an error
    func request<Response: HTTPRequest>(apiRequest: Response, completion: @escaping (Result<Data, Error>) -> Void)
}

struct APISession: APISessionContract {
    static let shared = APISession()
    private let session: URLSession
    private let interceptors: [APIInterceptor]
    
    init(interceptors: [APIInterceptor] = [APIInterceptor()]) {
        self.session = URLSession(configuration: .default)
        self.interceptors = interceptors
    }
    
    func request<Response: HTTPRequest>(apiRequest: Response, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            var request = try apiRequest.getRequest()
            interceptors.forEach { $0.intercept(&request) }
            session.dataTask(with: request) { data, response, error in
                if let error {
                    completion(.failure(error))
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(APIErrorResponse.network(apiRequest.path)))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200..<300:
                    // Represents a range of success codes ej. empty data for hero like
                    completion(.success(data ?? Data()))
                case 401:
                    // Represents an unauthorized error to provide feedback about wrong email or password
                    completion(.failure(APIErrorResponse.unauthorized(apiRequest.path)))
                default:
                    completion(.failure(APIErrorResponse.unknown(apiRequest.path)))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
