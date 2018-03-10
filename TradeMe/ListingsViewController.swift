//  Created by Oleg Chernyshenko on 10/03/18.

import UIKit

class ListingsViewController: UIViewController {
    var listings = [SearchResult.Listing]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        print("Listings: \(listings)")
    }
}
