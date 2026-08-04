import Foundation

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(
        networkClient: NetworkClient,
        storage: NftStorage
    ) {
        self.networkClient = networkClient
        self.storage = storage
    }

    @discardableResult
    func loadNft(
        id: String,
        completion: @escaping NftCompletion
    ) -> NetworkTask? {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return nil
        }

        let request = NFTRequest(id: id)

        return networkClient.send(
            request: request,
            type: Nft.self
        ) { [weak self] result in
            switch result {
            case .success(let nft):
                self?.storage.saveNft(nft)
                completion(.success(nft))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

