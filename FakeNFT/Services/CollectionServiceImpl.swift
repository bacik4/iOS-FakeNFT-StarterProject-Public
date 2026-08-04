import Foundation

final class CollectionServiceImpl: CollectionService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    @discardableResult
    func loadCollections(
        completion: @escaping CollectionsCompletion
    ) -> NetworkTask? {
        let request = CollectionsRequest()

        return networkClient.send(
            request: request,
            type: [NftCollection].self,
            onResponse: completion
        )
    }

    @discardableResult
    func loadCollection(
        id: String,
        completion: @escaping CollectionCompletion
    ) -> NetworkTask? {
        let request = CollectionRequestById(id: id)

        return networkClient.send(
            request: request,
            type: NftCollection.self,
            onResponse: completion
        )
    }
}
