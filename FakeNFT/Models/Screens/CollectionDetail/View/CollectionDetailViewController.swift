import UIKit

final class CollectionDetailViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let viewModel: CollectionDetailViewModel
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCollectionViewLayout()
    )
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initializer
    
    init(viewModel: CollectionDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        configureCollectionView()
        configureActivityIndicator()
        bindViewModel()
        
        viewModel.loadCollection()
    }
}

// MARK: - Configuration

private extension CollectionDetailViewController {
    
    func configureAppearance() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            NftCollectionViewCell.self,
            forCellWithReuseIdentifier:
                NftCollectionViewCell.reuseIdentifier
        )
        
        collectionView.register(
            CollectionDetailHeaderView.self,
            forSupplementaryViewOfKind:
                UICollectionView.elementKindSectionHeader,
            withReuseIdentifier:
                CollectionDetailHeaderView.reuseIdentifier
        )
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
    
    func configureActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            activityIndicator.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            )
        ])
    }
}

// MARK: - Layout

private extension CollectionDetailViewController {
    
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3.0),
            heightDimension: .estimated(190)
        )
        
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 4,
            bottom: 0,
            trailing: 4
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(190)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        
        let section = NSCollectionLayoutSection(
            group: group
        )
        
        section.interGroupSpacing = 16
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: 12,
            bottom: 16,
            trailing: 12
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(450)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(
            section: section
        )
    }
}

// MARK: - Binding

private extension CollectionDetailViewController {
    
    func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .loading:
                self.activityIndicator.startAnimating()
                self.collectionView.isHidden = true
                
            case .content:
                self.activityIndicator.stopAnimating()
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
                
            case .error(let message):
                self.activityIndicator.stopAnimating()
                self.collectionView.isHidden = true
                self.showError(message: message)
            }
        }
    }
}

// MARK: - Error

private extension CollectionDetailViewController {
    
    func showError(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString(
                "ShowError.message",
                comment: ""
            ),
            message: message,
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(
            title: NSLocalizedString(
                "Error.repeat",
                comment: ""
            ),
            style: .default
        ) { [weak self] _ in
            self?.viewModel.loadCollection()
        }
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString(
                "Alert.cancel",
                comment: ""
            ),
            style: .cancel
        )
        
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionDetailViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.numberOfNfts
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier:
                NftCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? NftCollectionViewCell else {
            fatalError("Unable to dequeue NftCollectionViewCell")
        }
        
        let model = viewModel.cellModel(at: indexPath.item)
        
        cell.configure(with: model)
        
        cell.onFavoriteButtonTapped = { [weak self] in
            self?.viewModel.toggleFavorite(at: indexPath.item)
        }
        
        cell.onCartButtonTapped = { [weak self] in
            self?.viewModel.toggleCart(at: indexPath.item)
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError(
                "Unsupported supplementary element kind: \(kind)"
            )
        }
        
        guard let header =
                collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier:
                        CollectionDetailHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? CollectionDetailHeaderView
        else {
            fatalError(
                "Unable to dequeue CollectionDetailHeaderView"
            )
        }
        
        if let model = viewModel.headerModel {
            header.configure(with: model)
        }
        
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension CollectionDetailViewController: UICollectionViewDelegate {}
