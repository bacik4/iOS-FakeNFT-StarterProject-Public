//
//  OrderRequestStatistic.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 04.08.2026.
//

import Foundation

struct OrderRequestStatistic: NetworkRequest {
    
    let orderId: String
    var endpoint: URL? {
        URL(
            string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)"
        )
    }
    
    var httpMethod: HttpMethod {
        .get
    }
    
    var dto: Dto? {
        nil
    }
}
