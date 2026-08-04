//
//  NFTCollectionCellViewModel.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 27.07.2026.
//

import Foundation

struct NFTCollectionCellViewModel {
    let id: String
    let imageURL: URL?
    let name: String
    let price: String
    let rating: Int
    var isLiked: Bool
    var isInCart: Bool
}
