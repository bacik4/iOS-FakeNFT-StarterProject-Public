import Foundation

final class CollectionDetailViewModel {

    // MARK: - Bindings

    var onStateChanged: ((CollectionDetailViewState) -> Void)?
    var onNftChanged: ((Int) -> Void)?

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

    private let synchronizationQueue = DispatchQueue(
        label: "collection.detail.nfts.synchronization"
    )

    private var collection: NftCollection?
    private var nfts: [Nft] = []

    private var favoriteNftIds: Set<String> = []
    private var cartNftIds: Set<String> = []

    // MARK: - Initializer

    init(
        collectionId: String,
        collectionService: CollectionService,
        nftService: NftService
    ) {
        self.collectionId = collectionId
        self.collectionService = collectionService
        self.nftService = nftService
    }

    // MARK: - Public Methods

    func loadCollection() {
        performOnMain { [weak self] in
            self?.onStateChanged?(.loading)
        }

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
        guard nfts.indices.contains(index) else {
            return
        }

        let nftId = nfts[index].id

        if favoriteNftIds.contains(nftId) {
            favoriteNftIds.remove(nftId)
        } else {
            favoriteNftIds.insert(nftId)
        }

        onNftChanged?(index)
    }

    func toggleCart(at index: Int) {
        guard nfts.indices.contains(index) else {
            return
        }

        let nftId = nfts[index].id

        if cartNftIds.contains(nftId) {
            cartNftIds.remove(nftId)
        } else {
            cartNftIds.insert(nftId)
        }

        onNftChanged?(index)
    }

    // MARK: - Private Methods

    private func loadNfts(ids: [String]) {
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

    private func performOnMain(
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
