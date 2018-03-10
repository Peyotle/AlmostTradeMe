//  Created by Oleg Chernyshenko on 10/03/18.

struct CategoryModel {
    var categories: [SearchResult.Category]
    var name: String
    var id: Int
    var parentCategoryId: Int?
}
