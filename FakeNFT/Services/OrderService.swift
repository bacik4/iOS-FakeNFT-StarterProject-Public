import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol OrderService {

    func loadOrder(
        completion: @escaping OrderCompletion
    )

    func updateOrder(
        nfts: [String],
        completion: @escaping OrderCompletion
    )
}
