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
    private let homeViewModel: HomeViewModelProtocol
    
    // MARK: - Lifecycle
    init(homeViewModel: HomeViewModelProtocol) {
        self.homeViewModel = homeViewModel
        super.init(nibName: "HomeView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
        homeViewModel.loadHeros()
    }
    
    // MARK: Collection View Configuration
    private func configureCollectionView() {
        let herosNib = UINib(nibName: HeroCell.identifier, bundle: Bundle(for: type(of: self)))
        let registration = UICollectionView.CellRegistration<HeroCell, HeroModel>(cellNib: herosNib) { cell, indexPath, hero in
            cell.setData(hero)
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, hero in
            // Applying the Adapter design pattern to transform a a domain model to a cell
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
        homeViewModel.loadHeros()
    }
    
    // MARK: - Binding
    private func bind() {
        homeViewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case .ready:
                self?.renderReady()
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
    
    private func renderReady() {
        activityIndicatorView.stopAnimating()
        collectionView.isHidden = false
        applySnapshot(heros: homeViewModel.heros)
    }
    
    private func renderError(_ message: String) {
        Logger.debug.error("\(message)")
        activityIndicatorView.stopAnimating()
        errorStackView.isHidden = false
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
        /* Should I use also de DS?
         guard let hero = dataSource?.itemIdentifier(for: indexPath) else {
            Logger.debug.error("Hero for \(indexPath) index path not found")
            return
        }
         */
        let hero = homeViewModel.heros[indexPath.row]
        // Show the screen without interacting with the view model since it does not require data
        // Also, according to the Single Responsaility principle the GET hero is going to be performed on Hero Detail
        show(HeroDetailBuilder().build(name: hero.name), sender: self)
    }
}
