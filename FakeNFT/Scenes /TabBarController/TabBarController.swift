import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Dependencies
    var servicesAssembly: ServicesAssembly!

    // MARK: - Lifecycle
init(servicesAssembly: ServicesAssembly) {
self.servicesAssembly = servicesAssembly
super.init(nibName: nil, bundle: nil)
}

@available(*, unavailable)
required init?(coder: NSCoder) {
nil
}

// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureModules()
    }
}

// MARK: - Configuration

private extension TabBarController {

func configureModules() {
setViewControllers(
[
makeCatalogNavigationController(),
makeCartNavigationController(),
makeStatisticNavigationController()
],
animated: false
)

tabBar.tintColor = .systemBlue
view.backgroundColor = .systemBackground
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
    private func setupTabs() {
        let catalogController = TestCatalogViewController(
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
func makeStatisticNavigationController() -> UIViewController {
let statisticViewModel = StatisticViewModel(
userService: servicesAssembly.userService
)

let statisticViewController = StatisticViewController(
viewModel: statisticViewModel,
nftService: servicesAssembly.nftService,
orderService: servicesAssembly.orderService
)

let navigationController = UINavigationController(
rootViewController: statisticViewController
)

navigationController.tabBarItem = UITabBarItem(
title: NSLocalizedString(
"Tab.statistic",
comment: ""
),
image: UIImage(
resource: .tabBarIconStatistic
)
)

return navigationController
}
}