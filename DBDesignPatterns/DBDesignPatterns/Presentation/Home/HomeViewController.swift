import UIKit

final class HomeViewController: UIViewController {
    // MARK: - ViewModel
    private let viewModel: HomeViewModel

    // MARK: - Lifecycle
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HomeView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.loadHeros()
    }
    
    // MARK: - Binding
    private func bind() {
        viewModel.onStateChanged.bind { state in
            // TODO: Implement
        }
    }
}
