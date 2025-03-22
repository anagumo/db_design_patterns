import Foundation

/// Represents a state on the screen
enum HomeStates: Equatable {
    case loading
    case success([HeroModel])
    case error(String)
}

protocol HomeViewModelProtocol {
    /// Implements a get hero list
    func loadHeros()
}

final class HomeViewModel: HomeViewModelProtocol {
    let onStateChanged = Binding<HomeStates>()
    let getHerosUseCase: GetHerosUseCase
    
    init(useCase: GetHerosUseCase) {
        self.getHerosUseCase = useCase
    }
    
    func loadHeros() {
        onStateChanged.update(.loading)
        getHerosUseCase.run { [weak self] result in
            do {
                let heros = try result.get()
                self?.onStateChanged.update(.success(heros))
            } catch let error as HeroError {
                self?.onStateChanged.update(.error(error.reason))
            } catch {
                self?.onStateChanged.update(.error(error.localizedDescription))
            }
        }
    }
}
