import Foundation
@testable import DBDesignPatterns

final class LoginUseCaseMock: LoginUseCaseProtocol {
    var receivedResponseData: Data?
    
    func run(username: String?, password: String?, completion: @escaping (Result<Void, LoginError>) -> Void) {
        
        do {
            let _ = try RegexLint.validate(data: username ?? "", matchWith: .email)
            
            guard receivedResponseData != nil else {
                completion(.failure(LoginError.network("Server error")))
                return
            }
            completion(.success(()))
        } catch {
            completion(.failure(LoginError.regex(.email)))
        }
    }
}
