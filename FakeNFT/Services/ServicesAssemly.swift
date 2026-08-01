final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }
    
    lazy var userService: UserService = {
        UserServiceImpl(networkClient: networkClient)
    }()
    
    lazy var nftService: NftService = {
        NftServiceImpl(networkClient: networkClient, storage: nftStorage)
    }()
}
