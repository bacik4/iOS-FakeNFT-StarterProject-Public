import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void

protocol NftService {

    @discardableResult
    func loadNft(
        id: String,
        completion: @escaping NftCompletion
    ) -> NetworkTask?
}
