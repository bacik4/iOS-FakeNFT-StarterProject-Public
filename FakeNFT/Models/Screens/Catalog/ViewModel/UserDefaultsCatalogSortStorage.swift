import Foundation

final class UserDefaultsCatalogSortStorage: CatalogSortStorage {

    // MARK: - Private Properties

    private enum StorageKeys {
        static let sortOption = "catalogSortOption"
    }

    private let userDefaults: UserDefaults

    // MARK: - Initializer

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - CatalogSortStorage

    func loadSortOption() -> CatalogSortOption? {
        guard let rawValue = userDefaults.string(
            forKey: StorageKeys.sortOption
        ) else {
            return nil
        }

        return CatalogSortOption(rawValue: rawValue)
    }

    func saveSortOption(_ option: CatalogSortOption) {
        userDefaults.set(
            option.rawValue,
            forKey: StorageKeys.sortOption
        )
    }
}

