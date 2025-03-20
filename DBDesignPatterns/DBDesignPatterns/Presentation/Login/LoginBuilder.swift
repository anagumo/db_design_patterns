import UIKit

final class LoginBuilder {
    func build() -> UIViewController {
        let useCase = LoginUseCase()
        let viewModel = LoginViewModel(loginUseCase: useCase)
        let loginViewController = LoginViewController(loginViewModel: viewModel)
        loginViewController.modalPresentationStyle = .fullScreen
        return loginViewController
    }
}
