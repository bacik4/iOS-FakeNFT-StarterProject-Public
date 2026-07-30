import Foundation

final class CollectionDetailViewModel {
    
    // MARK: - Bindings
    
    var onStateChanged: ((CollectionDetailViewState) -> Void)?
    var onNftChanged: ((Int) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Public Properties
    
    var numberOfNfts: Int {
        nfts.count
    }
    
    var headerModel: CollectionHeaderModel? {
        guard let collection else {
            return nil
        }
        
        return CollectionHeaderModel(
            name: collection.name,
            description: collection.description,
            author: collection.author,
            coverURL: collection.cover,
            websiteURL: collection.website
        )
    }
    
    var authorWebsiteURL: URL? {
        collection?.website
    }
    
    // MARK: - Private Properties
    
    private let collectionId: String
    private let collectionService: CollectionService
    private let nftService: NftService
    private let profileService: ProfileService
    
    private let synchronizationQueue = DispatchQueue(
        label: "collection.detail.nfts.synchronization"
    )
    
    private var collection: NftCollection?
    private var nfts: [Nft] = []
    private var profile: Profile?
    
    private var favoriteNftIds: Set<String> = []
    private var cartNftIds: Set<String> = []
    
    private var isUpdatingFavorites = false
    
    private let orderService: OrderService
    
    private var order: Order?
    private var isUpdatingCart = false
    
    // MARK: - Initializer
    
    init(
        collectionId: String,
        collectionService: CollectionService,
        nftService: NftService,
        profileService: ProfileService,
        orderService: OrderService
    ) {
        self.collectionId = collectionId
        self.collectionService = collectionService
        self.nftService = nftService
        self.profileService = profileService
        self.orderService = orderService
    }
    
    // MARK: - Public Methods
    
    func loadCollection() {
        performOnMain { [weak self] in
            self?.onStateChanged?(.loading)
        }
        
        loadProfile()
    }
    
    func cellModel(at index: Int) -> NftCellModel {
        let nft = nfts[index]
        
        return NftCellModel(
            id: nft.id,
            name: nft.name,
            imageURL: nft.images.first,
            rating: nft.rating,
            priceText: String(
                format: "%.2f ETH",
                nft.price
            ),
            isFavorite: favoriteNftIds.contains(nft.id),
            isInCart: cartNftIds.contains(nft.id)
        )
    }
    
    func nftId(at index: Int) -> String {
        nfts[index].id
    }
    
    func toggleFavorite(at index: Int) {
        guard nfts.indices.contains(index),
              let profile,
              !isUpdatingFavorites else {
            return
        }
        
        let nftId = nfts[index].id
        let previousLikes = profile.likes
        
        var updatedLikes = previousLikes
        
        if let likedIndex = updatedLikes.firstIndex(of: nftId) {
            updatedLikes.remove(at: likedIndex)
        } else {
            updatedLikes.append(nftId)
        }
        
        isUpdatingFavorites = true
        
        // Оптимистично обновляем интерфейс
        favoriteNftIds = Set(updatedLikes)
        onNftChanged?(index)
        
        profileService.updateProfile(
            profile: profile,
            likes: updatedLikes
        ) { [weak self] result in
            guard let self else {
                return
            }
            
            self.performOnMain { [weak self] in
                guard let self else {
                    return
                }
                
                self.isUpdatingFavorites = false
                
                switch result {
                case .success(let updatedProfile):
                    self.profile = updatedProfile
                    self.favoriteNftIds = Set(
                        updatedProfile.likes
                    )
                    
                    self.onNftChanged?(index)
                    
                case .failure(let error):
                    // Возвращаем прежнее состояние сердца
                    self.favoriteNftIds = Set(previousLikes)
                    
                    self.onNftChanged?(index)
                    self.onError?(
                        error.localizedDescription
                    )
                }
            }
        }
    }
    
    func toggleCart(at index: Int) {
        guard nfts.indices.contains(index),
              let order,
              !isUpdatingCart else {
            return
        }
        
        let nftId = nfts[index].id
        let previousNfts = order.nfts
        
        var updatedNfts = previousNfts
        
        if let nftIndex = updatedNfts.firstIndex(of: nftId) {
            updatedNfts.remove(at: nftIndex)
        } else {
            updatedNfts.append(nftId)
        }
        
        isUpdatingCart = true
        
        // Сразу меняем интерфейс
        cartNftIds = Set(updatedNfts)
        onNftChanged?(index)
        
        orderService.updateOrder(
            nfts: updatedNfts
        ) { [weak self] result in
            guard let self else {
                return
            }
            
            self.performOnMain { [weak self] in
                guard let self else {
                    return
                }
                
                self.isUpdatingCart = false
                
                switch result {
                case .success(let updatedOrder):
                    self.order = updatedOrder
                    self.cartNftIds = Set(updatedOrder.nfts)
                    self.onNftChanged?(index)
                    
                case .failure(let error):
                    // Возвращаем прежнее состояние
                    self.cartNftIds = Set(previousNfts)
                    self.onNftChanged?(index)
                    self.onError?(
                        error.localizedDescription
                    )
                }
            }
        }
    }
}

// MARK: - Loading

private extension CollectionDetailViewModel {
    
    func loadProfile() {
        profileService.loadProfile { [weak self] result in
            guard let self else {
                return
            }
            
            self.performOnMain { [weak self] in
                guard let self else {
                    return
                }
                
                switch result {
                case .success(let profile):
                    self.profile = profile
                    self.favoriteNftIds = Set(profile.likes)
                    self.loadOrder()
                    
                case .failure(let error):
                    self.onStateChanged?(
                        .error(error.localizedDescription)
                    )
                }
            }
        }
    }
    
    func loadCollectionData() {
        collectionService.loadCollection(
            id: collectionId
        ) { [weak self] result in
            guard let self else {
                return
            }
            
            self.performOnMain { [weak self] in
                guard let self else {
                    return
                }
                
                switch result {
                case .success(let collection):
                    self.collection = collection
                    self.loadNfts(ids: collection.nftIds)
                    
                case .failure(let error):
                    self.onStateChanged?(
                        .error(error.localizedDescription)
                    )
                }
            }
        }
    }
    
    func loadNfts(ids: [String]) {
        guard !ids.isEmpty else {
            performOnMain { [weak self] in
                guard let self else {
                    return
                }
                
                self.nfts = []
                self.onStateChanged?(.content)
            }
            
            return
        }
        
        let group = DispatchGroup()
        
        var loadedNfts = Array<Nft?>(
            repeating: nil,
            count: ids.count
        )
        
        var loadingError: Error?
        
        for (index, id) in ids.enumerated() {
            group.enter()
            
            nftService.loadNft(id: id) { [weak self] result in
                guard let self else {
                    group.leave()
                    return
                }
                
                self.synchronizationQueue.async {
                    switch result {
                    case .success(let nft):
                        loadedNfts[index] = nft
                        
                    case .failure(let error):
                        if loadingError == nil {
                            loadingError = error
                        }
                    }
                    
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else {
                return
            }
            
            if let loadingError {
                self.onStateChanged?(
                    .error(loadingError.localizedDescription)
                )
                
                return
            }
            
            self.nfts = loadedNfts.compactMap { $0 }
            self.onStateChanged?(.content)
        }
    }
    
    func performOnMain(
        _ block: @escaping () -> Void
    ) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(
                execute: block
            )
        }
    }
    
    private func loadOrder() {
        orderService.loadOrder { [weak self] result in
            guard let self else {
                return
            }
            
            self.performOnMain { [weak self] in
                guard let self else {
                    return
                }
                
                switch result {
                case .success(let order):
                    self.order = order
                    self.cartNftIds = Set(order.nfts)
                    self.loadCollectionData()
                    
                case .failure(let error):
                    self.onStateChanged?(
                        .error(error.localizedDescription)
                    )
                }
            }
        }
    }
}
