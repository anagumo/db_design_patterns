import UIKit

final class HeroDetailBuilder {
    /// Implements a controller creation using the Builder design pattern
    /// - Returns: according to the Liskov principle returns an object of type `(UIViewController)`
    func build(name: String) -> UIViewController {
        let useCase = GetHeroUseCase()
        let likeHero = LikeHeroUseCase()
        let viewModel = HeroDetailViewModel(getHeroUseCase: useCase, likeHeroUseCase: likeHero)
        let controller = HeroDetailViewController(name: name, heroDetailViewModel: viewModel)
        return controller
    }
}
