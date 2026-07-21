import Foundation

struct NftCollection: Decodable {
    let createdAt: String
    let name: String
    let cover: URL
    let nftIds: [String]
    let description: String
    let author: String
    let website: URL
    let id: String

    enum CodingKeys: String, CodingKey {
        case createdAt
        case name
        case cover
        case description
        case author
        case website
        case id
        case nftIds = "nfts"
    }
}
