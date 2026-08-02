//
//  UserCollectionViewModel.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 27.07.2026.
//

import Foundation

final class UserCollectionViewModel {
    
    // MARK: - Callback
    var onNFTsChanged: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onNFTChanged: ((Int) -> Void)?
    
    // MARK: - Public Properties
    var numberOfNFTs: Int {
        nfts.count
    }
    
    // MARK: - Private Properties
    private let nftService: NftService
    private let nftIDs: [String]
    
    private var nfts: [NFTCollectionCellViewModel] = []
    
    // MARK: - Initializer
    init(nftIDs: [String], nftService: NftService) {
        self.nftIDs = nftIDs
        self.nftService = nftService
    }
    
    // MARK: - Public Methods
    func getNft(at index: Int) -> NFTCollectionCellViewModel {
        nfts[index]
    }
    
    func loadNFTs() {
        onLoadingChanged?(true)
        
        guard !nftIDs.isEmpty else {
            nfts = []
            onNFTsChanged?()
            onLoadingChanged?(false)
            return
        }
        
        let group = DispatchGroup()
        let synchronizationQueue = DispatchQueue(label: Constants.DispatchGroup.queueLabel)
        var loadedNFTs = Array<NFTCollectionCellViewModel?>(repeating: nil, count: nftIDs.count)
        
        for (index, id) in nftIDs.enumerated() {
            group.enter()
            
            nftService.loadNft(id: id) { result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let nft):
                    let cellViewModel = NFTCollectionCellViewModel(
                        id: nft.id,
                        imageURL: nft.images.first,
                        name: nft.name,
                        price: "\(nft.price) ETH",
                        rating: nft.rating,
                        isLiked: false,
                        isInCart: false
                    )
                    
                    synchronizationQueue.sync {
                        loadedNFTs[index] = cellViewModel
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            self.nfts = loadedNFTs.compactMap { $0 }
            self.onNFTsChanged?()
            self.onLoadingChanged?(false)
        }
    }
    
    func toggleLike(at index: Int) {
        nfts[index].isLiked.toggle()
        onNFTsChanged?()
    }
    
    func toggleCart(at index: Int) {
        nfts[index].isInCart.toggle()
        onNFTChanged?(index)
    }
}
