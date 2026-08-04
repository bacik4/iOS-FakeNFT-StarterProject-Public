//
//  OrderModel.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 04.08.2026.
//

import Foundation

struct Order: Decodable {
    let id: String
    let nfts: [String]
}
