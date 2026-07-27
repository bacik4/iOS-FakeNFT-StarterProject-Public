import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCatalogModule()

        view.backgroundColor = .systemBackground
    }
    
    private func configureCatalogModule() {
        let catalogAssembly = CatalogAssembly(
            servicesAssembly: servicesAssembly
        )
        
        let catalogViewController = catalogAssembly.build()
        
        let navigationController = UINavigationController(rootViewController: catalogViewController)
        
        navigationController.tabBarItem = catalogTabBarItem
        
        viewControllers = [
            navigationController
        ]
    }
}
