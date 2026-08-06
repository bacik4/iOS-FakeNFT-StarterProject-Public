//
//  OrderServiceImplStatistic.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 04.08.2026.
//

import Foundation

final class OrderServiceImplStatistic: OrderService {
    
    // MARK: - Private Properties
    private let networkClient: NetworkClient
    private let orderId: String
    
    // MARK: - Initializer
    init(
        networkClient: NetworkClient,
        orderId: String = "1"
    ) {
        self.networkClient = networkClient
        self.orderId = orderId
    }
    
    // MARK: - OrderService
    @discardableResult func loadOrder(completion: @escaping OrderCompletion) -> NetworkTask? {
        let request = OrderRequestStatistic(orderId: orderId)
        
        return networkClient.send(
            request: request,
            type: Order.self,
            onResponse: completion
        )
    }
    
    @discardableResult func updateOrder(nfts: [String], completion: @escaping OrderCompletion) -> NetworkTask? {
        let dto = UpdateOrderDtoStatistic(nfts: nfts)
        
        let request = UpdateOrderRequestStatistic(
            orderId: orderId,
            dto: dto
        )
        
        return networkClient.send(
            request: request,
            type: Order.self,
            onResponse: completion
        )
    }
}
