import UIKit
import OSLog

final class HomeViewController: UIViewController {
    // MARK: - UI Components
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var errorStackView: UIStackView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private var errorLabel: UILabel!
    
    // MARK: - View Model
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
    
    // MARK: - UI Operations
    @IBAction func onTryAgainTapped(_ sender: UIButton) {
        Logger.debug.log("On try again tapped")
        viewModel.loadHeros()
    }
    
    // MARK: - Binding
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case let .success(heros):
                self?.renderSuccess(heros)
            case let .error(message):
                self?.renderError(message)
            }
        }
    }
    
    // MARK: - State Rendering
    private func renderLoading() {
        activityIndicatorView.startAnimating()
        errorStackView.isHidden = true
    }
    
    private func renderSuccess(_ heros: [Hero]) {
        activityIndicatorView.stopAnimating()
        collectionView.isHidden = false
        Logger.debug.log("\(heros.debugDescription)")
    }
    
    private func renderError(_ message: String) {
        activityIndicatorView.stopAnimating()
        errorStackView.isHidden = false
        Logger.debug.error("\(message)")
        errorLabel.text = message
    }
}
