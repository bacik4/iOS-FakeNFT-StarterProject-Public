import Foundation

struct Nft: Decodable {
    let createdAt: String
    let name: String
    let images: [URL]
<<<<<<< HEAD
    let name: String
    let price: Double
    let rating: Int
=======
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let website: URL
    let id: String
>>>>>>> c3a32af7f28360485ff8af444b27795b929470b8
}
