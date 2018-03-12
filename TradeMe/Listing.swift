//  Created by Oleg Chernyshenko on 12/03/18.

import Foundation

struct Listing: Codable {
    let listingId: Int
    let title: String
    let photos: [ListingPhoto]?

    private enum CodingKeys: String, CodingKey {
        case listingId = "ListingId"
        case title = "Title"
        case photos = "Photos"
    }
}

struct ListingPhoto: Codable {
    struct Value: Codable {
        let thumbnail: URL
        let large: URL

        private enum CodingKeys: String, CodingKey {
            case thumbnail = "Thumbnail"
            case large = "Large"
        }
    }
    let key: Int
    let value: Value

    private enum CodingKeys: String, CodingKey {
        case key = "Key"
        case value = "Value"
    }
}
