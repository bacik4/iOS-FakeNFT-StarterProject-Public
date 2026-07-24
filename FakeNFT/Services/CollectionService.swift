import Foundation

typealias CollectionsCompletion = (Result<[NftCollection], Error>) -> Void
typealias CollectionByIdCompletion = (Result<NftCollection, Error>) -> Void

protocol CollectionService {
    func loadCollections(completion: @escaping CollectionsCompletion)
    func loadCollection(id: String, completion: @escaping CollectionByIdCompletion)
}

final class CollectionServiceImpl: CollectionService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCollections(completion: @escaping CollectionsCompletion) {
        let request = CollectionsRequest()
        
        networkClient.send(
            request: request,
            type: [NftCollection].self
        ) { result in
            completion(result)
        }
    }
    
    func loadCollection(id: String, completion: @escaping CollectionByIdCompletion) {
        let request = CollectionRequestById(id: id)
        networkClient.send(
            request: request,
            type: NftCollection.self
        ) { result in
            completion(result)
        }
    }
}
