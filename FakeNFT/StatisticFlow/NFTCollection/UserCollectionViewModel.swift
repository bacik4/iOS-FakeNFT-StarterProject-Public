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
    var onError: ((String) -> Void)?
    
    // MARK: - Public Properties
    var numberOfNFTs: Int {
        nfts.count
    }
    
    // MARK: - Private Properties
    private let nftService: NftService
    private let orderService: OrderService
    private let nftIDs: [String]
    
    private var nfts: [NFTCollectionCellViewModel] = []
    private var order: Order?
    
    private var isUpdatingCart = false
    private var orderUpdateTask: NetworkTask?
    
    // MARK: - Initializer
    init(
        nftIDs: [String],
        nftService: NftService,
        orderService: OrderService
    ) {
        self.nftIDs = nftIDs
        self.nftService = nftService
        self.orderService = orderService
    }
    
    deinit {
        orderUpdateTask?.cancel()
    }
    
    // MARK: - Public Methods
    func getNft(at index: Int) -> NFTCollectionCellViewModel {
        nfts[index]
    }
    
    func loadNFTs() {
        onLoadingChanged?(true)
        let group = DispatchGroup()
        let synchronizationQueue = DispatchQueue(
            label: Constants.DispatchGroup.queueLabel
        )
        
        var loadedNFTs = Array<NFTCollectionCellViewModel?>(
            repeating: nil,
            count: nftIDs.count
        )
        
        var loadedOrder: Order?
        var loadingError: Error?
        
        group.enter()
        orderService.loadOrder { result in
            synchronizationQueue.sync {
                switch result {
                case .success(let order):
                    loadedOrder = order
                    
                case .failure(let error):
                    loadingError = error
                }
            }
            
            group.leave()
        }
        for (index, id) in nftIDs.enumerated() {
            group.enter()
            
            nftService.loadNft(id: id) { result in
                synchronizationQueue.sync {
                    switch result {
                    case .success(let nft):
                        loadedNFTs[index] = NFTCollectionCellViewModel(
                            id: nft.id,
                            imageURL: nft.images.first,
                            name: nft.name,
                            price: "\(nft.price) ETH",
                            rating: nft.rating,
                            isLiked: false,
                            isInCart: false
                        )
                        
                    case .failure(let error):
                        loadingError = error
                    }
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            self.onLoadingChanged?(false)
            
            if let loadingError {
                self.onError?(loadingError.localizedDescription)
                return
            }
            
            self.order = loadedOrder
            
            let cartNftIds = Set(loadedOrder?.nfts ?? [])
            
            self.nfts = loadedNFTs.compactMap { nft in
                guard var nft else {
                    return nil
                }
                nft.isInCart = cartNftIds.contains(nft.id)
                
                return nft
            }
            
            self.onNFTsChanged?()
        }
    }
    
    func toggleLike(at index: Int) {
        guard nfts.indices.contains(index) else { return }
        
        nfts[index].isLiked.toggle()
        onNFTChanged?(index)
    }
    
    func toggleCart(at index: Int) {
        guard nfts.indices.contains(index),
              let order,
              !isUpdatingCart else {
            return
        }
        
        let nftId = nfts[index].id
        let previousNfts = order.nfts
        
        var updatedNfts = previousNfts
        
        if let nftIndex = updatedNfts.firstIndex(of: nftId) {
            updatedNfts.remove(at: nftIndex)
        } else {
            updatedNfts.append(nftId)
        }
        
        isUpdatingCart = true
        
        nfts[index].isInCart.toggle()
        onNFTChanged?(index)
        
        orderUpdateTask = orderService.updateOrder(
            nfts: updatedNfts
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else {
                    return
                }
                
                self.orderUpdateTask = nil
                self.isUpdatingCart = false
                
                switch result {
                case .success(let updatedOrder):
                    self.order = updatedOrder
                    
                    self.nfts[index].isInCart =
                    updatedOrder.nfts.contains(nftId)
                    
                    self.onNFTChanged?(index)
                    
                case .failure(let error):
                    self.nfts[index].isInCart =
                    previousNfts.contains(nftId)
                    
                    self.onNFTChanged?(index)
                    self.onError?(
                        error.localizedDescription
                    )
                }
            }
        }
    }
}
