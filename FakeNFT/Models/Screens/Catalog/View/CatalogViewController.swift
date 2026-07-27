import UIKit

final class CatalogViewController: UIViewController {
    
    private let viewModel: CatalogViewModel
    private let collectionDetailAssembly: CollectionDetailAssembly
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: CatalogViewModel,
         collectionDetailAssembly: CollectionDetailAssembly
    ) {
        self.viewModel = viewModel
        self.collectionDetailAssembly = collectionDetailAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        configureTableView()
        configureActivityIndicator()
        bindViewModel()
        
        viewModel.loadCollections()
    }
    
    @objc
    private func didTapSortButton() {
        let alert = UIAlertController(
            title: NSLocalizedString("Catalog.sort.title", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let sortByNameAction = UIAlertAction(
            title: NSLocalizedString("Catalog.sort.name", comment: ""),
            style: .default
        ) { [weak self] _ in
            self?.viewModel.applySort(.name)
        }
        
        let sortByCountAction = UIAlertAction(
            title: NSLocalizedString("Catalog.sort.nftCount", comment: ""),
            style: .default
        ) { [weak self] _ in
            self?.viewModel.applySort(.nftCount)
        }
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Alert.close", comment: ""),
            style: .cancel
        )
        
        alert.addAction(sortByNameAction)
        alert.addAction(sortByCountAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

private extension CatalogViewController {
    
    func configureAppearance() {
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("Tab.catalog", comment: "")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease"),
            style: .plain,
            target: self,
            action: #selector(didTapSortButton)
        )
    }
}

private extension CatalogViewController {
    
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        
        tableView.register(
            CatalogCollectionCell.self,
            forCellReuseIdentifier: CatalogCollectionCell.reuseIdentifier
        )
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.numberOfCollections
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogCollectionCell.reuseIdentifier,
            for: indexPath
        ) as? CatalogCollectionCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.cellModel(at: indexPath.row)
        cell.configure(with: model)
        
        return cell
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let collectionId = viewModel.collectionId(at: indexPath.row)
        
        let detailViewController = collectionDetailAssembly.build(collectionId: collectionId)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

private extension CatalogViewController {
    
    func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .loading:
                self.activityIndicator.startAnimating()
                self.tableView.isHidden = true
                
            case .content:
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
                self.tableView.reloadData()
                
            case .error(let message):
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = true
                self.showError(message: message)
            }
        }
    }
}

private extension CatalogViewController {
    
    func configureActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

private extension CatalogViewController {
    
    func showError(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("ShowError.message", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Error.repeat", comment: ""),
                style: .default
            ) { [weak self] _ in
                self?.viewModel.loadCollections()
            }
        )
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Alert.cancel", comment: ""),
                style: .cancel
            )
        )
        
        present(alert, animated: true)
    }
}
