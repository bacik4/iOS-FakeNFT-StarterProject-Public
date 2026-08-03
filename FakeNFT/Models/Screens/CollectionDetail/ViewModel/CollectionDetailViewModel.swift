import Foundation

final class CollectionDetailViewModel {
    
    // MARK: - Bindings
    
    var onStateChanged: ((CollectionDetailViewState) -> Void)?
    var onNftChanged: ((Int) -> Void)?
    var onError: ((String) -> Void)?
    var onOpenAuthorWebsite: ((URL) -> Void)?
    var onOpenNftDetails: ((String) -> Void)?
    
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
    
    // MARK: - Dependencies
    
    private let collectionId: String
    private let collectionService: CollectionService
    private let nftService: NftService
    private let profileService: ProfileService
    private let orderService: OrderService
    
    // MARK: - Data
    
    private var collection: NftCollection?
    private var nfts: [Nft] = []
    private var profile: Profile?
    private var order: Order?
    
    private var favoriteNftIds: Set<String> = []
    private var cartNftIds: Set<String> = []
    
    // MARK: - Update State
    
    private var isUpdatingFavorites = false
    private var isUpdatingCart = false
    
    // MARK: - Loading State
    
    private let maximumConcurrentNftRequests = 4
    
    /// Изменяется при каждой новой загрузке или отмене.
    /// Старые completion не смогут изменить актуальное состояние.
    private var loadGeneration = 0
    
    private var initialLoadContext: InitialLoadContext?
    private var initialLoadingTasks: [InitialRequestKind: NetworkTask] = [:]
    
    private var nftLoadContext: NftLoadContext?
    private var nftLoadingTasks: [Int: NetworkTask] = [:]
    
    private var favoriteUpdateTask: NetworkTask?
    private var orderUpdateTask: NetworkTask?
    
    // MARK: - Supporting Types
    
    private enum InitialRequestKind: Hashable {
        case profile
        case order
        case collection
    }
    
    private final class InitialLoadContext {
        
        var profile: Profile?
        var order: Order?
        var collection: NftCollection?
        
        var completedRequests: Set<InitialRequestKind> = []
    }
    
    private final class NftLoadContext {
        
        let ids: [String]
        
        var results: [Nft?]
        var nextIndex = 0
        var activeRequestCount = 0
        var completedRequestCount = 0
        var completedIndexes: Set<Int> = []
        
        init(ids: [String]) {
            self.ids = ids
            self.results = Array(
                repeating: nil,
                count: ids.count
            )
        }
    }
    
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
    
    deinit {
        initialLoadingTasks.values.forEach {
            $0.cancel()
        }
        
        nftLoadingTasks.values.forEach {
            $0.cancel()
        }
        
        favoriteUpdateTask?.cancel()
        orderUpdateTask?.cancel()
    }
    
    // MARK: - Public Methods
    
    func loadCollection() {
        performOnMain { [weak self] in
            self?.startLoading()
        }
    }
    
    func cancelRequests() {
        performOnMain { [weak self] in
            guard let self else {
                return
            }
            
            self.loadGeneration += 1
            self.cancelActiveTasks()
        }
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
        
        let generation = loadGeneration
        let nftId = nfts[index].id
        let previousLikes = profile.likes
        
        var updatedLikes = previousLikes
        
        if let likedIndex = updatedLikes.firstIndex(of: nftId) {
            updatedLikes.remove(at: likedIndex)
        } else {
            updatedLikes.append(nftId)
        }
        
        isUpdatingFavorites = true
        
        // Оптимистичное обновление интерфейса
        favoriteNftIds = Set(updatedLikes)
        onNftChanged?(index)
        
        favoriteUpdateTask = profileService.updateProfile(
            profile: profile,
            likes: updatedLikes
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self,
                      self.loadGeneration == generation else {
                    return
                }
                
                self.favoriteUpdateTask = nil
                self.isUpdatingFavorites = false
                
                switch result {
                case .success(let updatedProfile):
                    self.profile = updatedProfile
                    self.favoriteNftIds = Set(
                        updatedProfile.likes
                    )
                    
                    self.onNftChanged?(index)
                    
                case .failure(let error):
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
        
        let generation = loadGeneration
        let nftId = nfts[index].id
        let previousNfts = order.nfts
        
        var updatedNfts = previousNfts
        
        if let nftIndex = updatedNfts.firstIndex(of: nftId) {
            updatedNfts.remove(at: nftIndex)
        } else {
            updatedNfts.append(nftId)
        }
        
        isUpdatingCart = true
        
        // Оптимистичное обновление интерфейса
        cartNftIds = Set(updatedNfts)
        onNftChanged?(index)
        
        orderUpdateTask = orderService.updateOrder(
            nfts: updatedNfts
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self,
                      self.loadGeneration == generation else {
                    return
                }
                
                self.orderUpdateTask = nil
                self.isUpdatingCart = false
                
                switch result {
                case .success(let updatedOrder):
                    self.order = updatedOrder
                    self.cartNftIds = Set(
                        updatedOrder.nfts
                    )
                    
                    self.onNftChanged?(index)
                    
                case .failure(let error):
                    self.cartNftIds = Set(previousNfts)
                    
                    self.onNftChanged?(index)
                    self.onError?(
                        error.localizedDescription
                    )
                }
            }
        }
    }
    
    func didTapAuthor() {
        guard let websiteURL = collection?.website else {
            return
        }
        
        onOpenAuthorWebsite?(websiteURL)
    }
    
    func didSelectNft(at index: Int) {
        guard nfts.indices.contains(index) else {
            return
        }
        
        onOpenNftDetails?(nfts[index].id)
    }
}

// MARK: - Initial Loading

private extension CollectionDetailViewModel {
    
    func startLoading() {
        loadGeneration += 1
        cancelActiveTasks()
        
        let generation = loadGeneration
        let context = InitialLoadContext()
        
        initialLoadContext = context
        
        collection = nil
        profile = nil
        order = nil
        nfts = []
        
        favoriteNftIds = []
        cartNftIds = []
        
        onStateChanged?(.loading)
        
        startProfileRequest(
            context: context,
            generation: generation
        )
        
        startOrderRequest(
            context: context,
            generation: generation
        )
        
        startCollectionRequest(
            context: context,
            generation: generation
        )
    }
    
    private func startProfileRequest(
        context: InitialLoadContext,
        generation: Int
    ) {
        let task = profileService.loadProfile { [weak self, weak context] result in
            DispatchQueue.main.async {
                guard let self,
                      let context else {
                    return
                }
                
                self.handleProfileResult(
                    result,
                    context: context,
                    generation: generation
                )
            }
        }
        
        storeInitialTask(
            task,
            kind: .profile,
            context: context,
            generation: generation
        )
    }
    
    private func startOrderRequest(
        context: InitialLoadContext,
        generation: Int
    ) {
        let task = orderService.loadOrder { [weak self, weak context] result in
            DispatchQueue.main.async {
                guard let self,
                      let context else {
                    return
                }
                
                self.handleOrderResult(
                    result,
                    context: context,
                    generation: generation
                )
            }
        }
        
        storeInitialTask(
            task,
            kind: .order,
            context: context,
            generation: generation
        )
    }
    
    private func startCollectionRequest(
        context: InitialLoadContext,
        generation: Int
    ) {
        let task = collectionService.loadCollection(
            id: collectionId
        ) { [weak self, weak context] result in
            DispatchQueue.main.async {
                guard let self,
                      let context else {
                    return
                }
                
                self.handleCollectionResult(
                    result,
                    context: context,
                    generation: generation
                )
            }
        }
        
        storeInitialTask(
            task,
            kind: .collection,
            context: context,
            generation: generation
        )
    }
    
    private func storeInitialTask(
        _ task: NetworkTask?,
        kind: InitialRequestKind,
        context: InitialLoadContext,
        generation: Int
    ) {
        guard let task else {
            return
        }
        
        guard loadGeneration == generation,
              initialLoadContext === context,
              !context.completedRequests.contains(kind) else {
            task.cancel()
            return
        }
        
        initialLoadingTasks[kind] = task
    }
    
    private func handleProfileResult(
        _ result: Result<Profile, Error>,
        context: InitialLoadContext,
        generation: Int
    ) {
        guard canHandleInitialResult(
            kind: .profile,
            context: context,
            generation: generation
        ) else {
            return
        }
        
        context.completedRequests.insert(.profile)
        initialLoadingTasks[.profile] = nil
        
        switch result {
        case .success(let profile):
            context.profile = profile
            
            finishInitialLoadingIfPossible(
                context: context,
                generation: generation
            )
            
        case .failure(let error):
            failInitialLoading(
                with: error,
                context: context,
                generation: generation
            )
        }
    }
    
    private func handleOrderResult(
        _ result: Result<Order, Error>,
        context: InitialLoadContext,
        generation: Int
    ) {
        guard canHandleInitialResult(
            kind: .order,
            context: context,
            generation: generation
        ) else {
            return
        }
        
        context.completedRequests.insert(.order)
        initialLoadingTasks[.order] = nil
        
        switch result {
        case .success(let order):
            context.order = order
            
            finishInitialLoadingIfPossible(
                context: context,
                generation: generation
            )
            
        case .failure(let error):
            failInitialLoading(
                with: error,
                context: context,
                generation: generation
            )
        }
    }
    
    private func handleCollectionResult(
        _ result: Result<NftCollection, Error>,
        context: InitialLoadContext,
        generation: Int
    ) {
        guard canHandleInitialResult(
            kind: .collection,
            context: context,
            generation: generation
        ) else {
            return
        }
        
        context.completedRequests.insert(.collection)
        initialLoadingTasks[.collection] = nil
        
        switch result {
        case .success(let collection):
            context.collection = collection
            
            finishInitialLoadingIfPossible(
                context: context,
                generation: generation
            )
            
        case .failure(let error):
            failInitialLoading(
                with: error,
                context: context,
                generation: generation
            )
        }
    }
    
    private func canHandleInitialResult(
        kind: InitialRequestKind,
        context: InitialLoadContext,
        generation: Int
    ) -> Bool {
        loadGeneration == generation &&
        initialLoadContext === context &&
        !context.completedRequests.contains(kind)
    }
    
    private func finishInitialLoadingIfPossible(
        context: InitialLoadContext,
        generation: Int
    ) {
        guard loadGeneration == generation,
              initialLoadContext === context,
              let profile = context.profile,
              let order = context.order,
              let collection = context.collection else {
            return
        }
        
        initialLoadingTasks.removeAll()
        initialLoadContext = nil
        
        self.profile = profile
        favoriteNftIds = Set(profile.likes)
        
        self.order = order
        cartNftIds = Set(order.nfts)
        
        self.collection = collection
        
        startNftLoading(
            ids: collection.nftIds,
            generation: generation
        )
    }
    
    private func failInitialLoading(
        with error: Error,
        context: InitialLoadContext,
        generation: Int
    ) {
        guard loadGeneration == generation,
              initialLoadContext === context else {
            return
        }
        
        initialLoadingTasks.values.forEach {
            $0.cancel()
        }
        
        initialLoadingTasks.removeAll()
        initialLoadContext = nil
        
        onStateChanged?(
            .error(error.localizedDescription)
        )
    }
}

// MARK: - NFT Loading

private extension CollectionDetailViewModel {
    
    func startNftLoading(
        ids: [String],
        generation: Int
    ) {
        guard loadGeneration == generation else {
            return
        }
        
        guard !ids.isEmpty else {
            nfts = []
            onStateChanged?(.content)
            return
        }
        
        let context = NftLoadContext(ids: ids)
        
        nftLoadContext = context
        
        startNextNftRequests(
            context: context,
            generation: generation
        )
    }
    
    private func startNextNftRequests(
        context: NftLoadContext,
        generation: Int
    ) {
        guard loadGeneration == generation,
              nftLoadContext === context else {
            return
        }
        
        while context.activeRequestCount
                < maximumConcurrentNftRequests,
              context.nextIndex < context.ids.count {
            
            let index = context.nextIndex
            let id = context.ids[index]
            
            context.nextIndex += 1
            context.activeRequestCount += 1
            
            let task = nftService.loadNft(
                id: id
            ) { [weak self, weak context] result in
                DispatchQueue.main.async {
                    guard let self,
                          let context else {
                        return
                    }
                    
                    self.handleNftResult(
                        result,
                        index: index,
                        context: context,
                        generation: generation
                    )
                }
            }
            
            storeNftTask(
                task,
                index: index,
                context: context,
                generation: generation
            )
        }
    }
    
    private func storeNftTask(
        _ task: NetworkTask?,
        index: Int,
        context: NftLoadContext,
        generation: Int
    ) {
        guard let task else {
            return
        }
        
        guard loadGeneration == generation,
              nftLoadContext === context,
              !context.completedIndexes.contains(index) else {
            task.cancel()
            return
        }
        
        nftLoadingTasks[index] = task
    }
    
    private func handleNftResult(
        _ result: Result<Nft, Error>,
        index: Int,
        context: NftLoadContext,
        generation: Int
    ) {
        guard loadGeneration == generation,
              nftLoadContext === context,
              !context.completedIndexes.contains(index) else {
            return
        }
        
        context.completedIndexes.insert(index)
        context.activeRequestCount -= 1
        context.completedRequestCount += 1
        
        nftLoadingTasks[index] = nil
        
        switch result {
        case .success(let nft):
            context.results[index] = nft
            
        case .failure(let error):
            failNftLoading(
                with: error,
                context: context,
                generation: generation
            )
            return
        }
        
        if context.completedRequestCount == context.ids.count {
            finishNftLoading(
                context: context,
                generation: generation
            )
        } else {
            startNextNftRequests(
                context: context,
                generation: generation
            )
        }
    }
    
    private func finishNftLoading(
        context: NftLoadContext,
        generation: Int
    ) {
        guard loadGeneration == generation,
              nftLoadContext === context else {
            return
        }
        
        nftLoadingTasks.removeAll()
        nftLoadContext = nil
        
        nfts = context.results.compactMap { $0 }
        
        onStateChanged?(.content)
    }
    
    private func failNftLoading(
        with error: Error,
        context: NftLoadContext,
        generation: Int
    ) {
        guard loadGeneration == generation,
              nftLoadContext === context else {
            return
        }
        
        nftLoadingTasks.values.forEach {
            $0.cancel()
        }
        
        nftLoadingTasks.removeAll()
        nftLoadContext = nil
        
        onStateChanged?(
            .error(error.localizedDescription)
        )
    }
}

// MARK: - Cancellation

private extension CollectionDetailViewModel {
    
    func cancelActiveTasks() {
        initialLoadingTasks.values.forEach {
            $0.cancel()
        }
        
        initialLoadingTasks.removeAll()
        initialLoadContext = nil
        
        nftLoadingTasks.values.forEach {
            $0.cancel()
        }
        
        nftLoadingTasks.removeAll()
        nftLoadContext = nil
        
        favoriteUpdateTask?.cancel()
        favoriteUpdateTask = nil
        isUpdatingFavorites = false
        
        orderUpdateTask?.cancel()
        orderUpdateTask = nil
        isUpdatingCart = false
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
}
