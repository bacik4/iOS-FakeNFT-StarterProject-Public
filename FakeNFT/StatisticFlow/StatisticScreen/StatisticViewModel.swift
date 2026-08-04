//
//  StatisticViewModel.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 26.07.2026.
//

import Foundation

enum StatisticSortType: String {
    case rating
    case name
}

final class StatisticViewModel {
    
    // MARK: - Callback
    var onUsersChanged: (() -> Void)?
    
    // MARK: - Public Properties
    var numberOfUsers: Int {
        users.count
    }
    
    // MARK: - Private Properties
    private let userService: UserService
    private let sortSettingsStorage: SortSettingsStorage
    
    private var users: [StatisticUserCellViewModel] = []
    private(set) var currentSortType: StatisticSortType
    
    
    // MARK: - Initializers
    init(
        userService: UserService,
        sortSettingsStorage: SortSettingsStorage = SortSettingsStorage()
    ) {
        self.userService = userService
        self.sortSettingsStorage = sortSettingsStorage
        
        currentSortType = sortSettingsStorage.loadStatisticSortType()
    }
    
    // MARK: - Public Methods
    func user(at index: Int) -> StatisticUserCellViewModel {
        users[index]
    }
    
    func didSelectUser(at index: Int) -> StatisticUserCellViewModel {
        users[index]
    }
    
    func loadUsers() {
        userService.loadUsers { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let users):
                self.users = users.map {
                    StatisticUserCellViewModel(
                        id: $0.id,
                        avatarURL: URL(string: $0.avatar),
                        name: $0.name,
                        rating: Int($0.rating) ?? 0,
                        description: $0.description,
                        nftCount: $0.nfts.count,
                        nftIDs: $0.nfts,
                        website: $0.website
                    )
                }
                
                self.applyCurrentSorting()
                self.onUsersChanged?()
                
            case .failure(let error):
                print("Ошибка загрузки пользователей: \(error)")
            }
        }
    }
    
    func sortUsers(by sortType: StatisticSortType) {
        guard currentSortType != sortType else { return }
        
        currentSortType = sortType
        sortSettingsStorage.saveStatisticSortType(sortType)
        
        applyCurrentSorting()
        onUsersChanged?()
    }
    
    // MARK: - Private Methods
    private func applyCurrentSorting() {
        switch currentSortType {
        case .rating:
            users.sort {
                $0.rating > $1.rating
            }
            
        case .name:
            users.sort {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }
}
