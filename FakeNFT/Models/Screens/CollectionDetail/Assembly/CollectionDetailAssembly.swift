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
            nftService: servicesAssembly.nftService,
            profileService: servicesAssembly.profileService,
            orderService: servicesAssembly.orderService
        )
        
        let nftDetailAssembly = NftDetailAssembly(
            servicesAssembler: servicesAssembly
        )
        
        let viewController = CollectionDetailViewController(
            viewModel: viewModel,
            nftDetailAssembly: nftDetailAssembly
        )
        
        return viewController
    }
}
