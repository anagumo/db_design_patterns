import Foundation

enum LoginState: Equatable {
    case loading
    case success
    case error(message: String)
}

protocol LoginViewModelProtocol {
    func login(username: String?, password: String?)
}

final class LoginViewModel: LoginViewModelProtocol {
    let loginUseCase: LoginUseCase
    let onStateChanged = Binding<LoginState>()
    
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
                self?.onStateChanged.update(.error(message: failure.reason))
            }
        }
    }
}
