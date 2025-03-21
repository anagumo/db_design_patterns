import UIKit

final class HomeBuilder {
    func build() -> UIViewController {
        let useCase = GetHerosUseCase()
        let viewModel = HomeViewModel(useCase: useCase)
        let controller = HomeViewController(viewModel: viewModel)
        controller.title = "Heros"
        return controller
    }
}
