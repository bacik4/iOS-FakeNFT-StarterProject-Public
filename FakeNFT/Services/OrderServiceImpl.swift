import Foundation

final class OrderServiceImpl: OrderService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadOrder(
        completion: @escaping OrderCompletion
    ) {
        let request = OrderRequest()

        networkClient.send(
            request: request,
            type: Order.self
        ) { result in
            completion(result)
        }
    }

    func updateOrder(
        nfts: [String],
        completion: @escaping OrderCompletion
    ) {
        let dto = OrderUpdateDto(nfts: nfts)
        let request = OrderUpdateRequest(dto: dto)

        networkClient.send(
            request: request,
            type: Order.self
        ) { result in
            completion(result)
        }
    }
}
