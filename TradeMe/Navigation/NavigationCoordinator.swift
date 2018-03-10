//  Created by Oleg Chernyshenko on 10/03/18.

import Foundation
import UIKit

protocol CategoryBrowserDelegate: class {
    func updateCategory(id: Int)
}

class NavigationCoordinator: CategoryBrowserDelegate {
    // Force unwrapping is intentional.
    // It should lead to an early crash in case of the wrong setup.
    var categoryNavigation: UINavigationController?
    var listingsNavigation: UINavigationController?
    var splitViewController: UISplitViewController?
    
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
        viewController.delegate = self
        categoryNavigation?.pushViewController(viewController
            , animated: true)
    }

    func presentListings(_ listings: [SearchResult.Listing]) {
        let viewController = ListingsViewController()
        viewController.listings = listings
        viewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//        [detailViewController.navigationController.navigationController popToRootViewControllerAnimated:YES]
        viewController.navigationController?.navigationController?.popToRootViewController(animated: true)
        listingsNavigation?.viewControllers = [viewController]
    }
}
