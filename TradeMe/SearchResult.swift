//  Created by Oleg Chernyshenko on 9/03/18.

import Foundation

struct SearchResult: Codable {
    struct Category: Codable {
        let categoryId: Int
        let name: String
        let category: String
        let count: Int
        let isLeaf: Bool?
        
        private enum CodingKeys: String, CodingKey {
            case categoryId = "CategoryId"
            case name = "Name"
            case category = "Category"
            case count = "Count"
            case isLeaf = "IsLeaf"
        }
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
    let totalCount: Int
    let page: Int
    let pageSize: Int
    let listings: [Listing]
    let categories: [Category]

    private enum CodingKeys: String, CodingKey {
        case totalCount = "TotalCount"
        case page = "Page"
        case pageSize = "PageSize"
        case listings = "List"
        case categories = "FoundCategories"
    }
}

extension SearchResult.Category {
    var hasSubcategory: Bool {
        return self.isLeaf == nil || self.isLeaf == false
    }
}
