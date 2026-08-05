//
//  OrderServiceStatistic.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 04.08.2026.
//

import Foundation

typealias OrderCompletionStatistic = (Result<Order, Error>) -> Void

protocol OrderServiceStatistic {
    
    @discardableResult func loadOrder(completion: @escaping OrderCompletion) -> NetworkTask?
    @discardableResult func updateOrder(nfts: [String], completion: @escaping OrderCompletion) -> NetworkTask?
}
