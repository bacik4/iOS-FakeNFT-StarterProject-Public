import UIKit

final class CollectionDetailViewController: UIViewController {

    private let viewModel: CollectionDetailViewModel

    init(viewModel: CollectionDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        bindViewModel()
        viewModel.loadCollection()
    }
}

private extension CollectionDetailViewController {

    func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self else { return }

            switch state {
            case .loading:
                break

            case .content:
                self.title = self.viewModel.headerModel?.name

            case .error(let message):
                self.showError(message: message)
            }
        }
    }

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
                self?.viewModel.loadCollection()
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
