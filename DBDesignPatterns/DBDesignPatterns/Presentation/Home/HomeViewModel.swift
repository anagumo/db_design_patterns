import Foundation

/// Represents a state on the screen
enum HomeStates: Equatable {
    case loading
    case ready
    case error(String)
}

protocol HomeViewModelProtocol {
    var onStateChanged: Binding<HomeStates> { get }
    /// Implements a get hero list
    func loadHeros()
    var heros: [HeroModel] { get }
}

final class HomeViewModel: HomeViewModelProtocol {
    let onStateChanged = Binding<HomeStates>()
    private let getHerosUseCase: GetHerosUseCaseProtocol
    private(set) var heros: [HeroModel] = []
    
    init(getHeroUseCase: GetHerosUseCaseProtocol) {
        self.getHerosUseCase = getHeroUseCase
    }
    
    func loadHeros() {
        onStateChanged.update(.loading)
        getHerosUseCase.run { [weak self] result in
            do {
                let heros = try result.get()
                self?.heros = heros
                self?.onStateChanged.update(.ready)
            } catch let error as HeroError {
                self?.onStateChanged.update(.error(error.reason))
            } catch {
                self?.onStateChanged.update(.error(error.localizedDescription))
            }
        }
    }
}
