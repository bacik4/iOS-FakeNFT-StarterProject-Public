//
//  UpdateOrderRequestStatistic.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 04.08.2026.
//

import Foundation

struct UpdateOrderRequestStatistic: NetworkRequest {
    
    let orderId: String
    let dto: Dto?
    var endpoint: URL? {
        URL(
            string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)"
        )
    }
    
    var httpMethod: HttpMethod {
        .put
    }
}
