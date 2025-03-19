import Foundation

/// Represent the screen states
enum SplashState: Equatable {
    case loading
    case ready
    case error
}

final class SplashViewModel {
    var onStateChange = Binding<SplashState>()
    
    /// Input
    func load() {
        onStateChange.update(.loading)
        // Execute this code on a secondary thread, to send data to UI layer is necessary change to the main thread
        // The Binding generic class makes the switch from Global queue -> Main thread
        DispatchQueue.global().asyncAfter(deadline:  .now() + 3) { [weak self] in
            self?.onStateChange.update(.ready)
        }
    }
}
