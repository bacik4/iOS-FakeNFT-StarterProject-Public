import Foundation

struct ProfileUpdateRequest: NetworkRequest {

    private let updateDto: ProfileUpdateDto

    var endpoint: URL? {
        URL(
            string: "\(RequestConstants.baseURL)/api/v1/profile/1"
        )
    }

    var httpMethod: HttpMethod = .put

    var dto: Dto? {
        updateDto
    }

    init(dto: ProfileUpdateDto) {
        self.updateDto = dto
    }
}

struct ProfileUpdateDto: Dto {

    let name: String
    let description: String
    let avatar: String
    let website: String
    let likes: [String]

    func asDictionary() -> [String: String] {
        [
            "name": name,
            "description": description,
            "avatar": avatar,
            "website": website,
            "likes": likes.joined(separator: ",")
        ]
    }
}
