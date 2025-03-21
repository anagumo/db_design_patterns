import Foundation

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
            // Before performing the login request, it is necessary to validate the input data.
            let username = try RegexLint.validate(data: username ?? "", matchWith: .email)
            let password = try RegexLint.validate(data: password ?? "", matchWith: .password)
            
            LoginAPIRequest(username: username, password: password).perform { [weak self] result in
                do {
                    let jwtData = try result.get()
                    self?.sessionDataSource.store(jwtData)
                    completion(.success(()))
                } catch let error as APIErrorResponse {
                    // Validate if it is an API response error since it is the type returned by the APISession.
                    completion(.failure(LoginError.network(error)))
                } catch {
                    completion(.failure(LoginError.uknown()))
                }
            }
        } catch let error as RegexLintError {
            completion(.failure(LoginError.regex(error)))
        } catch {
            completion(.failure(LoginError.uknown()))
        }
    }
}
