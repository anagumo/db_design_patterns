import Foundation

/// Represents a state on the screen
enum LoginState: Equatable {
    case loading
    case success
    case fullScreenError(String) // For blocking errors
    case inlineError(RegexLintError) // For errors on ui ej. below text fields
}

// Dependency inversion to test the view model
protocol LoginViewModelProtocol {
    var onStateChanged: Binding<LoginState> { get }
    /// Implements a user authentication
    /// - Parameters:
    ///   - username: an object of type `(String)` that represents the email of the user
    ///   - password: an object of type `(String)` that represents the password of the user
    func login(username: String?, password: String?)
}

final class LoginViewModel: LoginViewModelProtocol {
    // Represents a bridge between view model and ui to notify events
    let onStateChanged = Binding<LoginState>()
    private let loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    func login(username: String?, password: String?) {
        onStateChanged.update(.loading)
        loginUseCase.run(username: username, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.onStateChanged.update(.success)
            case let .failure(failure):
                guard let regexLintError = failure.regex else {
                    self?.onStateChanged.update(.fullScreenError(failure.reason))
                    return
                }
                self?.onStateChanged.update(.inlineError(regexLintError))
            }
        }
    }
}
