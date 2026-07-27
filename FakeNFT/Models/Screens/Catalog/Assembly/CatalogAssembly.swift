import UIKit

final class CatalogAssembly {
    
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func build() -> UIViewController {
        let viewModel = CatalogViewModel(
            collectionService: servicesAssembly.collectionService
        )
        
        let viewController = CatalogViewController(
            viewModel: viewModel
        )
        
        return viewController
    }
}

