//
//  UpdateOrderDtoStatistic.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 04.08.2026.
//

import Foundation

struct UpdateOrderDtoStatistic: Dto {
    
    let nfts: [String]
    
    private enum CodingKeys: String {
        case nfts
    }
    
    func asDictionary() -> [String: String] {
        [
            CodingKeys.nfts.rawValue: nfts.joined(separator: ",")
        ]
    }
}
