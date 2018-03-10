//  Created by Oleg Chernyshenko on 9/03/18.

import UIKit

class CategoryViewController: UIViewController {
    var categories = [SearchResult.Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        print("Categories: \(categories)")
    }
}

