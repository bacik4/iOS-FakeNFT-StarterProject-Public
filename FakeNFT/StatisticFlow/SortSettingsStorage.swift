//
//  SortSettingsStorage.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 01.08.2026.
//

import Foundation

final class SortSettingsStorage {
    
    private enum Keys {
        static let statisticSortType = "statisticSortType"
    }
    
    // MARK: - Private Properties
    private let userDefaults: UserDefaults
    
    // MARK: - Initializers
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Public Methods
    func saveStatisticSortType(_ sortType: StatisticSortType) {
        userDefaults.set(sortType.rawValue, forKey: Keys.statisticSortType)
    }
    
    func loadStatisticSortType() -> StatisticSortType {
        guard
            let savedValue = userDefaults.string(
                forKey: Keys.statisticSortType
            ),
            let sortType = StatisticSortType(rawValue: savedValue)
        else {
            return .rating
        }
        
        return sortType
    }
}
