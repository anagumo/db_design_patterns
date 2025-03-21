import UIKit

class HeroDetailViewController: UIViewController {
    // MARK: - UI Components
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var errorStackView: UIStackView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var photoImageView: AsyncImage!
    
    // MARK: - View Model
    private let name: String
    private let viewModel: HeroDetailViewModel
    
    // MARK: - Lifecycle
    /// name parameter represents the name of the hero and is requiered to render the detail
    init(name: String, viewModel: HeroDetailViewModel) {
        self.name = name
        self.viewModel = viewModel
        super.init(nibName: "HeroDetailView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        bind()
        viewModel.loadHero(name: name)
    }
    
    // MARK: - UI Operations
    @IBAction func onTryAgainTapped(_ sender: UIButton) {
        viewModel.loadHero(name: name)
    }
    
    @objc func favoriteBarButtonItemTapped(_ sender: UIBarButtonItem) {
        viewModel.likeHero()
    }
    
    // MARK: - Binding
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case let .success(hero):
                self?.renderSuccess(hero)
            case .liked:
                self?.renderLiked()
            case let .error(firstCharge, errorMessage):
                self?.renderError(errorMessage, firstCharge)
            }
        }
    }
    
    // MARK: State Rendering
    private func renderLoading() {
        activityIndicatorView.startAnimating()
        contentStackView.isHidden = true
        errorStackView.isHidden = true
    }
    
    private func renderSuccess(_ hero: HeroModel) {
        activityIndicatorView.stopAnimating()
        contentStackView.isHidden = false
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: hero.getFavoriteImage())
        navigationItem.rightBarButtonItem?.isEnabled = true
        photoImageView.setImage(hero.photo)
        descriptionLabel.text = hero.description
    }
    
    private func renderLiked() {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
    }
    
    private func renderError(_ errorMessage: String, _ firstCharge: Bool) {
        if firstCharge {
            activityIndicatorView.stopAnimating()
            errorStackView.isHidden = false
        } else {
            present(
                AlertBuilder().build(title: "Error", message: errorMessage),
                animated: true
            )
        }
    }
}

extension HeroDetailViewController {
    // MARK: - UI Customization
    private func customizeUI() {
        title = name
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteBarButtonItemTapped)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}
