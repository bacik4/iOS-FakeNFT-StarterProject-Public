final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
<<<<<<< HEAD
    
=======

    let imageLoader: ImageLoading

>>>>>>> c3a32af7f28360485ff8af444b27795b929470b8
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        imageLoader: ImageLoading = ImageLoader()
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.imageLoader = imageLoader
    }
<<<<<<< HEAD
    
    lazy var userService: UserService = {
        UserServiceImpl(networkClient: networkClient)
    }()
    
    lazy var nftService: NftService = {
        NftServiceImpl(networkClient: networkClient, storage: nftStorage)
    }()
    
    lazy var orderService: OrderService = {
        OrderServiceImpl(networkClient: networkClient)
    }()
=======

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
>>>>>>> c3a32af7f28360485ff8af444b27795b929470b8
}
