import Foundation

enum HeroDetailState: Equatable {
    case loading
    case ready
    case favorite
    case fullScreenError(String) // For blocking errors
    case inlineError(String) // For errors on ui, in this case im going to use it for an alert when the content is previous charged
}

protocol HeroDetailViewModelProtocol {
    var onStateChanged: Binding<HeroDetailState> { get }
    /// Implements a Get hero
    /// - Parameter name: an object of type `(String)` that represents the hero name ej. Gohan :'( (missing in the server)
    func loadHero(name: String)
    var hero: HeroModel? { get }
    /// Implements a hero like, this endpoint not performs a hero unlike
    func markHeroAsFavorite(_ identifier: String, currentFavorite: Bool)
}

final class HeroDetailViewModel: HeroDetailViewModelProtocol {
    let onStateChanged = Binding<HeroDetailState>()
    private let getHeroUseCase: GetHeroUseCaseProtocol
    private let markHeroAsFavoriteUseCase: MarkHeroAsFavoriteUseCaseProtocol
    private(set) var hero: HeroModel?
    
    init(getHeroUseCase: GetHeroUseCaseProtocol, markHeroAsFavoriteUseCase: MarkHeroAsFavoriteUseCaseProtocol) {
        self.getHeroUseCase = getHeroUseCase
        self.markHeroAsFavoriteUseCase = markHeroAsFavoriteUseCase
    }
    
    func loadHero(name: String) {
        onStateChanged.update(.loading)
        getHeroUseCase.run(name: name) { [weak self] result in
            do {
                let hero = try result.get()
                self?.hero = hero
                self?.onStateChanged.update(.ready)
            } catch let error as HeroError {
                self?.onStateChanged.update(.fullScreenError(error.reason))
            } catch {
                self?.onStateChanged.update(.fullScreenError(error.localizedDescription))
            }
        }
    }
    
    func markHeroAsFavorite(_ identifier: String, currentFavorite: Bool) {
        guard !currentFavorite else {
            onStateChanged.update(.inlineError("You have already marked this hero as favorite"))
            return
        }
        
        markHeroAsFavoriteUseCase.run(identifier: identifier) { [weak self] result in
            do {
                let _ = try result.get()
                self?.onStateChanged.update(.favorite)
            } catch let error as HeroError {
                self?.onStateChanged.update(.inlineError(error.reason))
            } catch {
                self?.onStateChanged.update(.inlineError(error.localizedDescription))
            }
        }
    }
}
