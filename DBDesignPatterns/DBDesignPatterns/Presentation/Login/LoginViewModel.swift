import Foundation

/// Represents a state on the screen
enum LoginState: Equatable {
    case loading
    case success
    case error(LoginError)
}

protocol LoginViewModelProtocol {
    /// Implements a user authentication
    /// - Parameters:
    ///   - username: an object of type `(String)` that represents the email of the user
    ///   - password: an object of type `(String)` that represents the password of the user
    func login(username: String?, password: String?)
}

final class LoginViewModel: LoginViewModelProtocol {
    // Represents a bridge between view model and ui to notify events
    let onStateChanged = Binding<LoginState>()
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func login(username: String?, password: String?) {
        onStateChanged.update(.loading)
        loginUseCase.run(username: username, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.onStateChanged.update(.success)
            case .failure(let failure):
                self?.onStateChanged.update(.error(failure))
            }
        }
    }
}
