//  Created by Oleg Chernyshenko on 12/03/18.

import UIKit

class CategoryTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with category: SearchResult.Category) {
        if category.hasSubcategory {
            self.accessoryType = .disclosureIndicator
        }

        self.textLabel?.text = category.name
        self.detailTextLabel?.text = "Count: \(category.count)"
    }
}
