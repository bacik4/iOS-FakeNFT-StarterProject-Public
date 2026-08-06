import UIKit

final class TabBarController: UITabBarController {
<<<<<<< HEAD
    
    private let servicesAssembly: ServicesAssembly
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let statisticTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistic", comment: ""),
        image: UIImage(resource: .tabBarIconStatistic),
        tag: 1
    )
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    private func setupTabs() {
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let statisticViewModel = StatisticViewModel(
            userService: servicesAssembly.userService
        )
        
        let statisticController = StatisticViewController(
            viewModel: statisticViewModel,
            nftService: servicesAssembly.nftService,
            orderService: servicesAssembly.orderService
        )
        
        statisticController.tabBarItem = statisticTabBarItem
        
        let statisticNavigationController = UINavigationController(
            rootViewController: statisticController
        )
        statisticNavigationController.tabBarItem = statisticTabBarItem
        
        viewControllers = [
            catalogController,
            statisticNavigationController
        ]
        
        tabBar.tintColor = .systemBlue
        view.backgroundColor = .systemBackground
=======

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
>>>>>>> c3a32af7f28360485ff8af444b27795b929470b8
    }
}
