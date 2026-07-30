//
//  UserService.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 26.07.2026.
//

import Foundation

typealias UsersCompletion = (Result<[User], Error>) -> Void

//MARK: - UserServiceProtocol
protocol UserService {
    func loadUsers(completion: @escaping UsersCompletion)
}

final class UserServiceImpl: UserService {
    
    // MARK: - Private Properties
    private let networkClient: NetworkClient
    
    // MARK: - Initializers
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public Methods
    func loadUsers(completion: @escaping UsersCompletion) {
        let request = UsersRequest()
        
        networkClient.send(request: request, type: [User].self) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
