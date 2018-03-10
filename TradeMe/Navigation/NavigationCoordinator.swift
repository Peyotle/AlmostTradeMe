//  Created by Oleg Chernyshenko on 10/03/18.

import Foundation
import UIKit

protocol CategoryBrowserDelegate: class {
    func updateCategory(id: Int, name: String)
}

class NavigationCoordinator: CategoryBrowserDelegate {
    var categoryNavigation: UINavigationController?
    var listingsNavigation: UINavigationController?
    var splitViewController: UISplitViewController?

    var selectedCategoryId: Int = 0
    var parentCategoryId: Int?
    var networking = NetworkManagerImpl()

    func start() {
        updateCategory(id: 0, name: "Category")
    }

    func updateCategory(id: Int, name: String) {
        networking.updateCategory(id) { [weak self] result in
            guard let result = result else {
                print("No Result")
                return
            }
            let model = CategoryModel(categories: result.categories,
                                      name: name,
                                      id: id,
                                      parentCategoryId: self?.parentCategoryId)
            self?.presentCategory(model)
            self?.presentListings(result.listings)

            self?.parentCategoryId = id
        }
    }

    func presentCategory(_ model: CategoryModel) {
        let viewController = CategoryViewController(with: model)

        viewController.delegate = self
        categoryNavigation?.pushViewController(viewController, animated: true)
    }

    func presentListings(_ listings: [SearchResult.Listing]) {
        let viewController = ListingsViewController()
        viewController.listings = listings
        viewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        listingsNavigation?.viewControllers = [viewController]
    }

    func navigateBack() {

    }
}
