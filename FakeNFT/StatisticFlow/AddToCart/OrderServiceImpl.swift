//
//  OrderServiceImpl.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 04.08.2026.
//

import Foundation

final class OrderServiceImpl: OrderService {
    
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
        let request = OrderRequest(
            orderId: orderId
        )
        
        return networkClient.send(
            request: request,
            type: Order.self,
            onResponse: completion
        )
    }
    
    @discardableResult func updateOrder(nfts: [String], completion: @escaping OrderCompletion) -> NetworkTask? {
        let dto = UpdateOrderDto(
            nfts: nfts
        )
        
        let request = UpdateOrderRequest(
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
