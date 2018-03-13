//  Created by Oleg Chernyshenko on 10/03/18.

struct Category: Codable {
    let number: String
    let name: String
    let subcategories: [Category]?
    let count: Int?
    let hasClassifieds: Bool?
    let isLeaf: Bool?

    private enum CodingKeys: String, CodingKey {
        case number = "Number"
        case name = "Name"
        case subcategories = "Subcategories"
        case count = "Count"
        case hasClassifieds = "HasClassifieds"
        case isLeaf = "IsLeaf"
    }
}

extension Category {
    var hasSubcategory: Bool {
        return self.isLeaf == nil || self.isLeaf == false
    }
}

extension Category: CustomStringConvertible {
    var description: String {
        let description = """
        
        number:         \(number)
        name:           \(name)
        subcategories:  \(String(describing: subcategories))
        count:          \(String(describing: count))
        hasClassifieds: \(String(describing: hasClassifieds))
        isLeaf:         \(String(describing: isLeaf))
        """
        return description
    }
}
