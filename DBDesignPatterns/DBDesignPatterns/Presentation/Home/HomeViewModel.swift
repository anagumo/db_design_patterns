import Foundation

enum HomeStates: Equatable {
    case loading
    case success
    case empty
    case error
}

protocol HomeViewModelProtocol {
    func loadHeros()
}

final class HomeViewModel: HomeViewModelProtocol {
    let onStateChanged = Binding<HomeStates>()
    
    func loadHeros() {
        // TODO: Implement
    }
}
