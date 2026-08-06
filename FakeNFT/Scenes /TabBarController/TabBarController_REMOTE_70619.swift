import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Dependencies

    var servicesAssembly: ServicesAssembly!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureModules()
    }
}

// MARK: - Configuration

private extension TabBarController {

    func configureModules() {
        let catalogNavigationController =
            makeCatalogNavigationController()

        let cartNavigationController =
            makeCartNavigationController()

        setViewControllers(
            [
                catalogNavigationController,
                cartNavigationController
            ],
            animated: false
        )
    }

    func makeCatalogNavigationController() -> UIViewController {
        let catalogAssembly = CatalogAssembly(
            servicesAssembly: servicesAssembly
        )

        let catalogViewController = catalogAssembly.build()

        let navigationController = UINavigationController(
            rootViewController: catalogViewController
        )

        navigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(
                "Tab.catalog",
                comment: ""
            ),
            image: UIImage(
                systemName: "square.stack.3d.up"
            ),
            selectedImage: UIImage(
                systemName: "square.stack.3d.up.fill"
            )
        )

        return navigationController
    }

    func makeCartNavigationController() -> UIViewController {
        let cartViewController = CartViewController()

        let navigationController = UINavigationController(
            rootViewController: cartViewController
        )

        navigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(
                "Tab.cart",
                value: "Корзина",
                comment: ""
            ),
            image: UIImage(
                systemName: "cart"
            ),
            selectedImage: UIImage(
                systemName: "cart.fill"
            )
        )

        return navigationController
    }
}
