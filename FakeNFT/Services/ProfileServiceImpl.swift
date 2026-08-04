import Foundation

final class ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    @discardableResult
    func loadProfile(
        completion: @escaping ProfileCompletion
    ) -> NetworkTask? {
        let request = ProfileRequest()

        return networkClient.send(
            request: request,
            type: Profile.self,
            onResponse: completion
        )
    }

    @discardableResult
    func updateProfile(
        profile: Profile,
        likes: [String],
        completion: @escaping ProfileCompletion
    ) -> NetworkTask? {
        let dto = ProfileUpdateDto(
            name: profile.name,
            description: profile.description,
            avatar: profile.avatar,
            website: profile.website,
            likes: likes
        )

        let request = ProfileUpdateRequest(dto: dto)

        return networkClient.send(
            request: request,
            type: Profile.self,
            onResponse: completion
        )
    }
}

