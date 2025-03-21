import UIKit

final class HeroDetailBuilder {
    func build(name: String) -> UIViewController {
        let useCase = GetHeroUseCase()
        let viewModel = HeroDetailViewModel(useCase: useCase)
        let controller = HeroDetailViewController(name: name, viewModel: viewModel)
        return controller
    }
}
