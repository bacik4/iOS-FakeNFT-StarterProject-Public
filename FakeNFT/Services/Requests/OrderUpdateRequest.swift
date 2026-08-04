import Foundation

struct OrderUpdateRequest: NetworkRequest {

    private let updateDto: OrderUpdateDto

    var endpoint: URL? {
        URL(
            string: "\(RequestConstants.baseURL)/api/v1/orders/1"
        )
    }

    var httpMethod: HttpMethod {
        .put
    }

    var dto: Dto? {
        updateDto
    }

    init(dto: OrderUpdateDto) {
        self.updateDto = dto
    }
}

struct OrderUpdateDto: Dto {

    let nfts: [String]

    func asDictionary() -> [String: String] {
        [
            "nfts": nfts.joined(separator: ",")
        ]
    }
}
