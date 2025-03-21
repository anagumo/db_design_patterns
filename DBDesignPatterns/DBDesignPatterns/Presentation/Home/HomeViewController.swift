import UIKit
import OSLog

enum HerosSection {
    case heros
}

final class HomeViewController: UIViewController {
    // MARK: - UI Components
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var errorStackView: UIStackView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private var errorLabel: UILabel!
    
    // MARK: DataSource
    typealias DataSource = UICollectionViewDiffableDataSource<HerosSection, HeroModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HerosSection, HeroModel>
    private var dataSource: DataSource?
    
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
        configureCollectionView()
        bind()
        viewModel.loadHeros()
    }
    
    // MARK: CollectionView Configuration
    private func configureCollectionView() {
        let herosNib = UINib(nibName: HeroCell.identifier, bundle: Bundle(for: type(of: self)))
        let registration = UICollectionView.CellRegistration<HeroCell, HeroModel>(cellNib: herosNib) { cell, indexPath, hero in
            cell.setData(hero)
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, hero in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: hero)
        })
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    private func applySnapshot(heros: [HeroModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.heros])
        snapshot.appendItems(heros)
        dataSource?.apply(snapshot)
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
    
    private func renderSuccess(_ heros: [HeroModel]) {
        activityIndicatorView.stopAnimating()
        collectionView.isHidden = false
        Logger.debug.log("Heros list has \(heros.count) items")
        applySnapshot(heros: heros)
    }
    
    private func renderError(_ message: String) {
        activityIndicatorView.stopAnimating()
        errorStackView.isHidden = false
        Logger.debug.error("\(message)")
        errorLabel.text = message
    }
}

// MARK: CollectionView Delegates
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberCollumn: CGFloat = 2
        let itemWidth = (collectionView.frame.size.width - 32) / numberCollumn
        return CGSize(width: itemWidth, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hero = dataSource?.itemIdentifier(for: indexPath) else {
            Logger.debug.error("Hero for \(indexPath) index path not found")
            return
        }
        // Show the screen without interacting with the view model since it does not require data
        // Also, the GetHerosAPIRequest for this hero is a responsibility of the HeroDetailViewModel
        show(HeroDetailBuilder().build(name: hero.name), sender: self)
    }
}
