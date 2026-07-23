import UIKit

final class TabBarController: UITabBarController {
    
    private let servicesAssembly: ServicesAssembly
    private let catalogTabBarItem = UITabBarItem(title: NSLocalizedString("Tab.catalog", comment: ""), image: UIImage(systemName: "square.stack.3d.up.fill"), tag: 0)
    private let statisticTabBarItem = UITabBarItem(title: NSLocalizedString("Tab.statistic", comment: ""), image: UIImage(resource: .tabBarIconStatistic), tag: 1)
    
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
        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        catalogController.tabBarItem = catalogTabBarItem
        
        let statisticController = StatisticViewController()
        statisticController.tabBarItem = statisticTabBarItem
        
        let statisticNavigationController = UINavigationController(rootViewController: statisticController)
        statisticNavigationController.tabBarItem = statisticTabBarItem
        
        viewControllers = [
            catalogController,
            statisticNavigationController
        ]
        
        tabBar.tintColor = .systemBlue
        view.backgroundColor = .systemBackground
    }
}
