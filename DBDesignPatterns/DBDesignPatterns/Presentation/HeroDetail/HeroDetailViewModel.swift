import Foundation

enum HeroDetailState: Equatable {
    case loading
    case success(HeroModel)
    case like
    // The flag represents two kind of errors: full screen and alerts
    // Should I split them in two different states?
    case error(firstCharge: Bool, String)
}

protocol HeroDetailViewModelProtocol {
    /// Implements a Get hero
    /// - Parameter name: an object of type `(String)` that represents the hero name ej. Gohan :'( (missing in the server)
    func loadHero(name: String)
    /// Implements a hero like, this endpoint not performs a hero unlike
    func likeHero()
}

final class HeroDetailViewModel: HeroDetailViewModelProtocol {
    let onStateChanged = Binding<HeroDetailState>()
    private let getHeroUseCase: GetHeroUseCase
    private let likeHeroUseCase: LikeHeroUseCase
    private var hero: HeroModel?
    
    init(useCase: GetHeroUseCase, likeHeroUseCase: LikeHeroUseCase) {
        self.getHeroUseCase = useCase
        self.likeHeroUseCase = likeHeroUseCase
    }
    
    func loadHero(name: String) {
        onStateChanged.update(.loading)
        getHeroUseCase.run(name: name) { [weak self] result in
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
                self?.onStateChanged.update(.like)
            } catch {
                self?.onStateChanged.update(.error(firstCharge: false, "There was an error marking as liked"))
            }
        }
    }
}
