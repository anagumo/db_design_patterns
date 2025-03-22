import UIKit

final class LoginBuilder {
    /// Implements a controller creation using the Builder design pattern
    /// - Returns: according to the Liskov principle returns an object of type `(UIViewController)`
    func build() -> UIViewController {
        let useCase = LoginUseCase()
        let viewModel = LoginViewModel(loginUseCase: useCase)
        let controller = LoginViewController(loginViewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}
