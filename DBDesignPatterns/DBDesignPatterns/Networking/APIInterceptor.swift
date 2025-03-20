import Foundation

protocol APIInterceptorProtocol {
    func intercept(_ request: inout URLRequest)
}

/// Implements an Interceptor to intercep API requests and responses, ej. headers
final class APIInterceptor: APIInterceptorProtocol {
    private let sessionDataSource: SessionDataSourceProtocol
    
    init(sessionDataSource: SessionDataSourceProtocol = SessionDataSource.shared) {
        self.sessionDataSource = sessionDataSource
    }
    
    /// Implements a request interception to set Authorization header
    /// - Parameter request: represent the request and is inout to mutate the param: let to var
    func intercept(_ request: inout URLRequest) {
        guard let session = sessionDataSource.get() else {
            return
        }
        
        request.setValue(
            "Bearer \(String(decoding: session, as: UTF8.self))",
            forHTTPHeaderField: "Authorization"
        )
    }
}
