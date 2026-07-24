import Foundation

final class CatalogViewModel {
    
    private let collectionService: CollectionService
    
    init(collectionService: CollectionService) {
        self.collectionService = collectionService
    }
    
    private var collections: [NftCollection] = []
    private var displayedCollections: [NftCollection] = []
    
    private var currentSortOption: CatalogSortOption = .nftCount
    
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
                DispatchQueue.main.async {
                    self.collections = collections
                    self.applySort(self.currentSortOption)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.onStateChanged?(.error(error.localizedDescription))
                }
            }
        }
    }
    
    func applySort(_ option: CatalogSortOption) {
        currentSortOption = option
        
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
