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
    
    lazy var userService: UserService = {
        UserServiceImpl(networkClient: networkClient)
    }()
    
    lazy var nftService: NftService = {
        NftServiceImpl(networkClient: networkClient, storage: nftStorage)
    }()
    
    lazy var orderService: OrderService = {
        OrderServiceImpl(networkClient: networkClient)
    }()
    
    
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
    
}
