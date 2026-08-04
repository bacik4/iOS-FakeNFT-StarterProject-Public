final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    let imageLoader: ImageLoading

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        imageLoader: ImageLoading = ImageLoader()
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.imageLoader = imageLoader
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var collectionService: CollectionService {
        CollectionServiceImpl(
            networkClient: networkClient
        )
    }

    var profileService: ProfileService {
        ProfileServiceImpl(
            networkClient: networkClient
        )
    }

    var orderService: OrderService {
        OrderServiceImpl(
            networkClient: networkClient
        )
    }
}
