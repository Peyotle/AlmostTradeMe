//  Created by Oleg Chernyshenko on 9/03/18.

import Foundation

struct SearchResult: Codable {

    let totalCount: Int
    let page: Int
    let pageSize: Int
    let listings: [Listing]

    private enum CodingKeys: String, CodingKey {
        case totalCount = "TotalCount"
        case page = "Page"
        case pageSize = "PageSize"
        case listings = "List"
    }

    struct Listing: Codable {
        let listingId: Int
        let title: String
        let category: String
        let pictureHref: URL?

        private enum CodingKeys: String, CodingKey {
            case listingId = "ListingId"
            case title = "Title"
            case category = "Category"
            case pictureHref = "PictureHref"
        }
    }
}
