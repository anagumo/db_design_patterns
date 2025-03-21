import Foundation

enum HomeStates: Equatable {
    case loading
    case success
    case error
}

protocol HomeViewModelProtocol {
    func loadHeros()
}

final class HomeViewModel: HomeViewModelProtocol {
    let onStateChanged = Binding<HomeStates>()
    
    func loadHeros() {
        onStateChanged.update(.loading)
        // TODO: Replace by the call to the use case
        DispatchQueue.global().asyncAfter(deadline:  .now() + 3) { [weak self] in
            self?.onStateChanged.update(.error)
        }
    }
}
