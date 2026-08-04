//
//  OrderService.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 04.08.2026.
//

import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol OrderService {
    
    @discardableResult func loadOrder(completion: @escaping OrderCompletion) -> NetworkTask?
    @discardableResult func updateOrder(nfts: [String], completion: @escaping OrderCompletion) -> NetworkTask?
}
