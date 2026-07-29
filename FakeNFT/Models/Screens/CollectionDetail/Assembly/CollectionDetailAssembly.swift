import UIKit

final class CollectionDetailAssembly {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build(collectionId: String) -> UIViewController {
        let viewModel = CollectionDetailViewModel(
            collectionId: collectionId,
            collectionService: servicesAssembly.collectionService,
            nftService: servicesAssembly.nftService
        )

        let viewController = CollectionDetailViewController(
            viewModel: viewModel
        )

        return viewController
    }
}

