import UIKit

// Closed to extension by default until we need to open
// View has not Singleton patterns
final class SplashViewController: UIViewController {
    // MARK: - UI Components
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    // MARK: - ViewModel
    private let viewModel: SplashViewModel
    
    // MARK: Lifecycle
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SplashView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Call to subscribe to the view model events
        bind()
        viewModel.load()
    }
    
    // MARK: Binding
    func bind() {
        viewModel.onStateChange.bind { [weak self] state in
            switch state {
            case .loading:
                self?.setAnimation(true)
            case .ready:
                self?.setAnimation(false)
                self?.present(LoginBuilder().build(), animated: true)
            case .error:
                self?.setAnimation(false)
            }
        }
    }
    
    // MARK: - UI Operations
    private func setAnimation(_ animating: Bool) {
        switch activityIndicatorView.isAnimating {
        case true where !animating:
            activityIndicatorView.stopAnimating()
        case false where animating:
            activityIndicatorView.startAnimating()
        default: break
        }
    }
}

// iOS 15 supports preview as SwiftUI
/*#Preview {
    SplashBuilder().build()
}*/
