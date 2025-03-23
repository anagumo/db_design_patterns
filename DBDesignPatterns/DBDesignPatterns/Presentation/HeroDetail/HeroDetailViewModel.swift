import Foundation

enum HeroDetailState: Equatable {
    case loading
    case success(HeroModel)
    case like
    case fullScreenError(String) // For blocking errors
    case inlineError(String) // For errors on ui, in this case im going to use it for an alert when the content is previous charged
}

protocol HeroDetailViewModelProtocol {
    /// Implements a Get hero
    /// - Parameter name: an object of type `(String)` that represents the hero name ej. Gohan :'( (missing in the server)
    func loadHero(name: String)
    /// Implements a hero like, this endpoint not performs a hero unlike
    var hero: HeroModel? { get set } // Exposed for testing purposes
    func likeHero()
}

final class HeroDetailViewModel: HeroDetailViewModelProtocol {
    let onStateChanged = Binding<HeroDetailState>()
    private let getHeroUseCase: GetHeroUseCaseProtocol
    private let likeHeroUseCase: LikeHeroUseCaseProtocol
    internal var hero: HeroModel?
    
    init(getHeroUseCase: GetHeroUseCaseProtocol, likeHeroUseCase: LikeHeroUseCaseProtocol) {
        self.getHeroUseCase = getHeroUseCase
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
                self?.onStateChanged.update(.fullScreenError(error.reason))
            } catch {
                self?.onStateChanged.update(.fullScreenError(error.localizedDescription))
            }
        }
    }
    
    func likeHero() {
        guard let hero, !hero.favorite else {
            onStateChanged.update(.inlineError("You have already liked this hero"))
            return
        }
        
        likeHeroUseCase.run(identifier: hero.identifier) { [weak self] result in
            do {
                let _ = try result.get()
                self?.onStateChanged.update(.like)
            } catch let error as HeroError {
                self?.onStateChanged.update(.inlineError(error.reason))
            } catch {
                self?.onStateChanged.update(.inlineError(error.localizedDescription))
            }
        }
    }
}
