import UIKit

final class HomeBuilder {
    func build() -> UIViewController {
        let viewModel = HomeViewModel()
        let controller = HomeViewController(viewModel: viewModel)
        return controller
    }
}
