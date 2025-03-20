import Foundation

protocol APISessionContract {
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
    
    func request<Response: HTTPRequest>(apiRequest: Response, completion: @escaping (Result<Data, any Error>) -> Void) {
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
                    completion(.success(data ?? Data()))
                default:
                    completion(.failure(APIErrorResponse.network(apiRequest.path)))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
