import Foundation

private enum StorageKeys {
    static let sortOption = "catalogSortOption"
}

final class CatalogViewModel {
    
    private let collectionService: CollectionService
    
    init(collectionService: CollectionService) {
        self.collectionService = collectionService
        
        if let savedValue = UserDefaults.standard.string(
            forKey: StorageKeys.sortOption
        ),
           let savedOption = CatalogSortOption(rawValue: savedValue) {
            currentSortOption = savedOption
        } else {
            currentSortOption = .nftCount
        }
    }
    
    private var collections: [NftCollection] = []
    private var displayedCollections: [NftCollection] = []
    
    private var currentSortOption: CatalogSortOption
    
    var onStateChanged: ((CatalogViewState) -> Void)?
    
    var numberOfCollections: Int {
        displayedCollections.count
    }
    
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
            guard let self else { return }
            switch result {
            case .success(let collections):
                self.collections = collections
                self.applySort(self.currentSortOption)
            case .failure(let error):
                self.onStateChanged?(.error(error.localizedDescription))
            }
        }
    }
    
    func applySort(_ option: CatalogSortOption) {
        currentSortOption = option
        
        UserDefaults.standard.set(
            option.rawValue,
            forKey: StorageKeys.sortOption
        )
        
        switch option {
        case .name:
            displayedCollections = collections.sorted { first, second in
                first.name.localizedCaseInsensitiveCompare(second.name) == .orderedAscending
            }
            
        case .nftCount:
            displayedCollections = collections.sorted { first, second in
                first.nftIds.count > second.nftIds.count
            }
        }
        onStateChanged?(.content)
    }
}
