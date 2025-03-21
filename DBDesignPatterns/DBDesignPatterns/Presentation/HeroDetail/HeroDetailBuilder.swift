import UIKit

final class HeroDetailBuilder {
    func build(name: String) -> UIViewController {
        let useCase = GetHeroUseCase()
        let likeHero = LikeHeroUseCase()
        let viewModel = HeroDetailViewModel(useCase: useCase, likeHeroUseCase: likeHero)
        let controller = HeroDetailViewController(name: name, viewModel: viewModel)
        return controller
    }
}
