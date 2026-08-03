import Foundation

final class CatalogViewModel {

    // MARK: - Bindings

    var onStateChanged: ((CatalogViewState) -> Void)?

    // MARK: - Public Properties

    var numberOfCollections: Int {
        displayedCollections.count
    }

    // MARK: - Private Properties

    private let collectionService: CollectionService
    private let sortStorage: CatalogSortStorage

    private var collections: [NftCollection] = []
    private var displayedCollections: [NftCollection] = []

    private var currentSortOption: CatalogSortOption

    // MARK: - Initializer

    init(
        collectionService: CollectionService,
        sortStorage: CatalogSortStorage
    ) {
        self.collectionService = collectionService
        self.sortStorage = sortStorage

        currentSortOption =
            sortStorage.loadSortOption() ?? .nftCount
    }

    // MARK: - Public Methods

    func cellModel(at index: Int) -> CatalogCellModel {
        let collection = displayedCollections[index]

        return CatalogCellModel(
            name: collection.name,
            coverURL: collection.cover,
            nftCountText: "\(collection.nftIds.count) NFT"
        )
    }

    func collectionId(at index: Int) -> String {
        displayedCollections[index].id
    }

    func loadCollections() {
        onStateChanged?(.loading)

        collectionService.loadCollections { [weak self] result in
            guard let self else {
                return
            }

            DispatchQueue.main.async {
                switch result {
                case .success(let collections):
                    self.collections = collections
                    self.applySort(
                        self.currentSortOption,
                        shouldSave: false
                    )

                case .failure(let error):
                    self.onStateChanged?(
                        .error(error.localizedDescription)
                    )
                }
            }
        }
    }

    func applySort(_ option: CatalogSortOption) {
        applySort(
            option,
            shouldSave: true
        )
    }
}

// MARK: - Sorting

private extension CatalogViewModel {

    func applySort(
        _ option: CatalogSortOption,
        shouldSave: Bool
    ) {
        currentSortOption = option

        if shouldSave {
            sortStorage.saveSortOption(option)
        }

        switch option {
        case .name:
            displayedCollections = collections.sorted {
                first,
                second in

                first.name.localizedCaseInsensitiveCompare(
                    second.name
                ) == .orderedAscending
            }

        case .nftCount:
            displayedCollections = collections.sorted {
                first,
                second in

                first.nftIds.count > second.nftIds.count
            }
        }

        onStateChanged?(.content)
    }
}
