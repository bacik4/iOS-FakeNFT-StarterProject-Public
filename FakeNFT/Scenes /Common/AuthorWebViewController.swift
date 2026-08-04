import UIKit
import WebKit

final class AuthorWebViewController: UIViewController {

    // MARK: - Private Properties

    private let url: URL

    private let webView = WKWebView(
        frame: .zero,
        configuration: WKWebViewConfiguration()
    )

    private let activityIndicator = UIActivityIndicatorView(
        style: .large
    )

    // MARK: - Initializer

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
        configureWebView()
        configureActivityIndicator()
        loadWebsite()
    }
}

// MARK: - Configuration

private extension AuthorWebViewController {

    func configureAppearance() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
    }

    func configureWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            webView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            webView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            webView.bottomAnchor.constraint(
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
                equalTo: view.centerXAnchor
            ),
            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }

    func loadWebsite() {
        activityIndicator.startAnimating()

        let request = URLRequest(url: url)
        webView.load(request)
    }
}

// MARK: - WKNavigationDelegate

extension AuthorWebViewController: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation?
    ) {
        activityIndicator.stopAnimating()
    }

    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation?,
        withError error: Error
    ) {
        activityIndicator.stopAnimating()
        showError(message: error.localizedDescription)
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation?,
        withError error: Error
    ) {
        activityIndicator.stopAnimating()
        showError(message: error.localizedDescription)
    }

    private func showError(message: String) {
        guard presentedViewController == nil else {
            return
        }

        let alert = UIAlertController(
            title: NSLocalizedString(
                "ShowError.message",
                comment: ""
            ),
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)
    }
}
