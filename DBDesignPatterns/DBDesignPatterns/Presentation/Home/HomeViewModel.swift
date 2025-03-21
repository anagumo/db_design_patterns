import Foundation

enum HomeStates: Equatable {
    case loading
    case success([HeroModel])
    case error(String)
}

protocol HomeViewModelProtocol {
    func loadHeros()
}

final class HomeViewModel: HomeViewModelProtocol {
    let onStateChanged = Binding<HomeStates>()
    let useCase: GetHerosUseCase
    
    init(useCase: GetHerosUseCase) {
        self.useCase = useCase
    }
    
    func loadHeros() {
        onStateChanged.update(.loading)
        useCase.run { [weak self] result in
            do {
                let heros = try result.get()
                // Validate first if the heros list is empty
                guard !heros.isEmpty else {
                    self?.onStateChanged.update(.error("Empty heros list"))
                    return
                }
                self?.onStateChanged.update(.success(heros))
            } catch let error as APIErrorResponse {
                self?.onStateChanged.update(.error(error.message))
            } catch {
                self?.onStateChanged.update(.error("Uknown server error"))
            }
        }
    }
}
