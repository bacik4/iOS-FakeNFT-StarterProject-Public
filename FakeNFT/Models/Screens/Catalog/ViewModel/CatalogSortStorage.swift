import Foundation

protocol CatalogSortStorage {
    func loadSortOption() -> CatalogSortOption?
    func saveSortOption(_ option: CatalogSortOption)
}
