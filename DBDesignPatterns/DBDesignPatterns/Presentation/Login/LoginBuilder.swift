import UIKit

final class LoginBuilder {
    func build() -> UIViewController {
        let useCase = LoginUseCase()
        let viewModel = LoginViewModel(loginUseCase: useCase)
        let controller = LoginViewController(loginViewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}
