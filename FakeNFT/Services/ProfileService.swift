import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadProfile(
        completion: @escaping ProfileCompletion
    )

    func updateProfile(
        profile: Profile,
        likes: [String],
        completion: @escaping ProfileCompletion
    )
}

final class ProfileServiceImpl: ProfileService {

    // MARK: - Private Properties

    private let networkClient: NetworkClient

    // MARK: - Initializer

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Public Methods

    func loadProfile(
        completion: @escaping ProfileCompletion
    ) {
        let request = ProfileRequest()

        networkClient.send(
            request: request,
            type: Profile.self
        ) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateProfile(
        profile: Profile,
        likes: [String],
        completion: @escaping ProfileCompletion
    ) {
        let dto = ProfileUpdateDto(
            name: profile.name,
            description: profile.description,
            avatar: profile.avatar,
            website: profile.website,
            likes: likes
        )

        let request = ProfileUpdateRequest(dto: dto)

        networkClient.send(
            request: request,
            type: Profile.self
        ) { result in
            switch result {
            case .success(let updatedProfile):
                completion(.success(updatedProfile))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
