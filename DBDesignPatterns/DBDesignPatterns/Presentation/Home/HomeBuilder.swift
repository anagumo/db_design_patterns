import UIKit

final class HomeBuilder {
    /// Implements a controller creation using the Builder design pattern
    /// - Returns: according to the Liskov principle returns an object of type `(UIViewController)`
    func build() -> UIViewController {
        let useCase = GetHerosUseCase()
        let viewModel = HomeViewModel(useCase: useCase)
        let controller = HomeViewController(viewModel: viewModel)
        controller.title = "Heros"
        return controller
    }
}
