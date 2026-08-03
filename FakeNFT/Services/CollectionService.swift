import Foundation

typealias CollectionsCompletion =
    (Result<[NftCollection], Error>) -> Void

typealias CollectionCompletion =
    (Result<NftCollection, Error>) -> Void

protocol CollectionService {

    @discardableResult
    func loadCollections(
        completion: @escaping CollectionsCompletion
    ) -> NetworkTask?

    @discardableResult
    func loadCollection(
        id: String,
        completion: @escaping CollectionCompletion
    ) -> NetworkTask?
}
