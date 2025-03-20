import Foundation

struct LoginError: Error {
    let reason: String
    
    init(reason: String) {
        self.reason = reason
    }
    
    init(from regex: RegexPattern) {
        switch regex {
        case .email:
            reason = "Email format is invalid"
        case .password:
            reason = "The password must have at least 8 characters"
        }
    }
}

protocol LoginUseCaseProtocol {
    func run(username: String?, password: String?, completion: @escaping (Result<Void, LoginError>) -> Void)
}

final class LoginUseCase: LoginUseCaseProtocol {
    private let sessionDataSource: SessionDataSourceProtocol
    
    init(sessionDataSource: SessionDataSourceProtocol = SessionDataSource.shared) {
        self.sessionDataSource = sessionDataSource
    }
    
    func run(username: String?, password: String?, completion: @escaping (Result<Void, LoginError>) -> Void) {
        do {
            let username = try RegexLint.validate(data: username ?? "", matchWith: .email)
            let password = try RegexLint.validate(data: password ?? "", matchWith: .password)
            
            LoginAPIRequest(username: username, password: password).perform { [weak self] result in
                do {
                    let jwtData = try result.get()
                    self?.sessionDataSource.store(jwtData)
                    completion(.success(()))
                } catch {
                    completion(.failure(LoginError(reason: "Unknown error")))
                }
            }
        } catch let error as LoginError {
            completion(.failure(error))
        } catch {
            completion(.failure(LoginError(reason: "Unknown error")))
        }
    }
}
