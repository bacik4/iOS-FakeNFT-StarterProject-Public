import Foundation

typealias ProfileCompletion =
    (Result<Profile, Error>) -> Void

protocol ProfileService {

    @discardableResult
    func loadProfile(
        completion: @escaping ProfileCompletion
    ) -> NetworkTask?

    @discardableResult
    func updateProfile(
        profile: Profile,
        likes: [String],
        completion: @escaping ProfileCompletion
    ) -> NetworkTask?
}
