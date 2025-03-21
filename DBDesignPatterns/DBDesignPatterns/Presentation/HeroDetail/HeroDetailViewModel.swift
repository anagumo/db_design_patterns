import Foundation

enum HeroDetailState: Equatable {
    case loading
    case success(HeroModel)
    case error(String)
}

protocol HeroDetailViewModelProtocol {
    func loadHero(name: String)
}

final class HeroDetailViewModel: HeroDetailViewModelProtocol {
    let onStateChanged = Binding<HeroDetailState>()
    let useCase: GetHeroUseCase
    
    init(useCase: GetHeroUseCase) {
        self.useCase = useCase
    }
    
    func loadHero(name: String) {
        onStateChanged.update(.loading)
        useCase.run(name: name) { [weak self] result in
            do {
                let hero = try result.get()
                self?.onStateChanged.update(.success(hero))
            } catch let error as HeroError {
                self?.onStateChanged.update(.error(error.reason))
            } catch {
                self?.onStateChanged.update(.error(error.localizedDescription))
            }
        }
    }
}
