//
//  StatisticUserCellViewModel.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 26.07.2026.
//

import Foundation

struct StatisticUserCellViewModel {
    let id: String
    let avatarURL: URL?
    let name: String
    let rating: Int
    let description: String?
    let nftCount: Int
    let nftIDs: [String]
    let website: String
}
