import Foundation

final class OrderServiceImpl: OrderService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    @discardableResult
    func loadOrder(
        completion: @escaping OrderCompletion
    ) -> NetworkTask? {
        let request = OrderRequest()

        return networkClient.send(
            request: request,
            type: Order.self,
            onResponse: completion
        )
    }

    @discardableResult
    func updateOrder(
        nfts: [String],
        completion: @escaping OrderCompletion
    ) -> NetworkTask? {
        let dto = OrderUpdateDto(nfts: nfts)
        let request = OrderUpdateRequest(dto: dto)

        return networkClient.send(
            request: request,
            type: Order.self,
            onResponse: completion
        )
    }
}
