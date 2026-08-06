//
//  OrderModelStatistic.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 04.08.2026.
//

import Foundation

struct OrderStatistic: Decodable {
    let id: String
    let nfts: [String]
}
