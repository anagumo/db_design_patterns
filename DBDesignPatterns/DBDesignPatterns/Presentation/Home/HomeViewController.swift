import UIKit

final class HomeViewController: UIViewController {
    // MARK: - UI Components
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var errorStackView: UIStackView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
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
        viewModel.loadHeros()
    }
    
    // MARK: - Binding
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case .success:
                self?.renderSuccess()
            case .error:
                self?.renderError()
            }
        }
    }
    
    // MARK: - State Rendering
    private func renderLoading() {
        activityIndicatorView.startAnimating()
        errorStackView.isHidden = true
    }
    
    private func renderSuccess() {
        activityIndicatorView.stopAnimating()
        collectionView.isHidden = false
    }
    
    private func renderError() {
        activityIndicatorView.stopAnimating()
        errorStackView.isHidden = false
    }
}
