import UIKit
import OSLog

class HeroDetailViewController: UIViewController {
    // MARK: - UI Components
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var errorStackView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var photoImageView: AsyncImage!
    
    // MARK: - View Model
    private let name: String
    private let heroDetailViewModel: HeroDetailViewModel
    
    // MARK: - Lifecycle
    // name parameter is set in the init because is required to render this screen
    init(name: String, heroDetailViewModel: HeroDetailViewModel) {
        self.name = name
        self.heroDetailViewModel = heroDetailViewModel
        super.init(nibName: "HeroDetailView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        bind()
        heroDetailViewModel.loadHero(name: name)
    }
    
    // MARK: - UI Operations
    @IBAction func onTryAgainTapped(_ sender: UIButton) {
        Logger.debug.log("On try again button tapped")
        heroDetailViewModel.loadHero(name: name)
    }
    
    @objc func likeBarButtonItemTapped(_ sender: UIBarButtonItem) {
        Logger.debug.log("On like bar button item tapped")
        heroDetailViewModel.likeHero()
    }
    
    // MARK: - Binding
    private func bind() {
        heroDetailViewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case let .success(hero):
                self?.renderSuccess(hero)
            case .like:
                self?.renderLike()
            case let .fullScreenError(message):
                self?.renderFullScreenError(message)
            case let .inlineError(message):
                self?.renderInlineError(message)
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
    
    private func renderLike() {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
    }
    
    private func renderFullScreenError(_ message: String) {
        activityIndicatorView.stopAnimating()
        errorStackView.isHidden = false
        errorLabel.text = message
    }
    
    private func renderInlineError(_ message: String) {
        present(
            AlertBuilder().build(title: "Error", message: message),
            animated: true
        )
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
            action: #selector(likeBarButtonItemTapped)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}
