//
//  StatisticViewModel.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 26.07.2026.
//

import Foundation

final class StatisticViewModel {
    
    //MARK: - Callback
    var onUsersChanged: (() -> Void)?
    
    // MARK: - Public Properties
    var numberOfUsers: Int {
        users.count
    }
    
    // MARK: - Private Properties
    private let userService: UserService
    private var users: [StatisticUserCellViewModel] = []
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    // MARK: - Public Methods
    func user(at index: Int) -> StatisticUserCellViewModel {
        users[index]
    }
    
    func loadUsers() {
        userService.loadUsers { [weak self] result in
            switch result {
                
            case .success(let users):
                self?.users = users
                    .map {
                        StatisticUserCellViewModel(
                            avatarURL: URL(string: $0.avatar),
                            name: $0.name,
                            rating: Int($0.rating) ?? 0
                        )
                    }
                    .sorted {
                        $0.rating > $1.rating
                    }
                
                self?.onUsersChanged?()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didSelectUser(at index: Int) {
        let user = users[index]
    }
}
