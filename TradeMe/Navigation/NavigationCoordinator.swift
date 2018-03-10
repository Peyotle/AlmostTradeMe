//  Created by Oleg Chernyshenko on 10/03/18.

import Foundation
import UIKit

class NavigationCoordinator {
    // Force unwrapping is intentional.
    // It should lead to an early crash in case of the wrong setup.
    var categoryNavigation: UINavigationController?
    var listingsNavigation: UINavigationController?
    var networking = NetworkManager()

    func start() {
        updateCategory(id: 0)
    }

    func updateCategory(id: Int) {
        networking.updateCategory(id) { [weak self] result in
            guard let result = result else {
                print("No Result")
                return
            }
            self?.presentCategory(result.categories)
            self?.presentListings(result.listings)
        }
    }

    func presentCategory(_ categories: [SearchResult.Category]) {
        let viewController = CategoryViewController()
        viewController.categories = categories
        categoryNavigation?.pushViewController(viewController
            , animated: true)
    }

    func presentListings(_ listings: [SearchResult.Listing]) {
        let viewController = ListingsViewController()
        viewController.listings = listings
        listingsNavigation?.pushViewController(viewController, animated: true)
    }
}
