import Foundation

/// Сетевая модель коллекции NFT, получаемая от API.
struct NftCollection: Decodable {

    /// Дата создания коллекции.
    let createdAt: String

    /// Название коллекции.
    let name: String

    /// URL обложки коллекции.
    let cover: URL

    /// Идентификаторы NFT, входящих в коллекцию.
    let nftIds: [String]

    /// Описание коллекции.
    let description: String

    /// Автор коллекции.
    let author: String

    /// URL сайта коллекции.
    let website: URL

    /// Уникальный идентификатор коллекции.
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
