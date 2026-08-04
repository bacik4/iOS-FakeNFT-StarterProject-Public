import UIKit

final class CatalogAssembly {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build() -> UIViewController {
        let viewModel = CatalogViewModel(
            collectionService:
                servicesAssembly.collectionService,
            sortStorage:
                UserDefaultsCatalogSortStorage()
        )

        let collectionDetailAssembly =
            CollectionDetailAssembly(
                servicesAssembly: servicesAssembly
            )

        let viewController = CatalogViewController(
            viewModel: viewModel,
            collectionDetailAssembly:
                collectionDetailAssembly,
            imageLoader: servicesAssembly.imageLoader
        )

        return viewController
    }
}
