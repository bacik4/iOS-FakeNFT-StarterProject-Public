//
//  UsersRequest.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 26.07.2026.
//

import Foundation

struct UsersRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users")
    }
    
    var dto: Dto?
}
