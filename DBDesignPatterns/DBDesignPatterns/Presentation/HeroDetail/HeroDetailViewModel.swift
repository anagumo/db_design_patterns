import Foundation

enum HeroDetailState: Equatable {
    case loading
    case success(HeroModel)
    case liked
    case error(firstCharge: Bool, String)
}

protocol HeroDetailViewModelProtocol {
    func loadHero(name: String)
}

final class HeroDetailViewModel: HeroDetailViewModelProtocol {
    let onStateChanged = Binding<HeroDetailState>()
    private let useCase: GetHeroUseCase
    private let likeHeroUseCase: LikeHeroUseCase
    private var hero: HeroModel?
    
    init(useCase: GetHeroUseCase, likeHeroUseCase: LikeHeroUseCase) {
        self.useCase = useCase
        self.likeHeroUseCase = likeHeroUseCase
    }
    
    func loadHero(name: String) {
        onStateChanged.update(.loading)
        useCase.run(name: name) { [weak self] result in
            do {
                let hero = try result.get()
                self?.hero = hero
                self?.onStateChanged.update(.success(hero))
            } catch let error as HeroError {
                self?.onStateChanged.update(.error(firstCharge: true, error.reason))
            } catch {
                self?.onStateChanged.update(.error(firstCharge: true, error.localizedDescription))
            }
        }
    }
    
    func likeHero() {
        guard let hero, !hero.favorite else {
            onStateChanged.update(.error(firstCharge: false, "You have already liked this hero"))
            return
        }
        
        likeHeroUseCase.run(identifier: hero.identifier) { [weak self] result in
            do {
                let _ = try result.get()
                self?.onStateChanged.update(.liked)
            } catch {
                self?.onStateChanged.update(.error(firstCharge: false, "There was an error marking as liked"))
            }
        }
    }
}
