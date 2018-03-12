//  Created by Oleg Chernyshenko on 12/03/18.

import UIKit

class SplitNavigationUIManager {
    let splitViewController: UISplitViewController
    let listingsNavigation: UINavigationController
    let categoryNavigation: UINavigationController
    var showListingsAction: (() -> ())?
    var showCategoriesAction: (() -> ())?

    init(with splitViewController: UISplitViewController,
         listingsNavigation: UINavigationController,
         categoryNavigation: UINavigationController) {
        self.splitViewController = splitViewController
        self.listingsNavigation = listingsNavigation
        self.categoryNavigation = categoryNavigation
    }

    func showNavigationButtonsIfNeeded() {
        if splitViewController.isCollapsed {
            addNavigationButtons()
        } else {
            removeNavigationButtons()
        }
    }
    func addNavigationButtons() {
        print("Number of VC: \(splitViewController.viewControllers.count)")
        guard let activeViewController = splitViewController.viewControllers.first else { return }
        
        if let categoriesController = categoryNavigation.topViewController {
            let navigationButton = UIBarButtonItem(title: "Listings", style: .plain, target: self, action: #selector(self.showListings))
            categoriesController.navigationItem.setRightBarButton(navigationButton, animated: false)
        }

        if let listingsController = listingsNavigation.topViewController {
            let navigationButton = UIBarButtonItem(title: "Show Categories", style: .plain, target: self, action: #selector(self.showCategories))
            listingsController.navigationItem.setRightBarButton(navigationButton, animated: true)
        }
    }

    func removeNavigationButtons() {
        if let categoriesController = categoryNavigation.topViewController {
            categoriesController.navigationItem.setRightBarButton(nil, animated: true)
        }

        if let listingsController = listingsNavigation.viewControllers.first {
            listingsController.navigationItem.setRightBarButton(nil, animated: true)
        }
    }

    // MARK: - Compact width navigation
    @objc func showListings() {
        showListingsAction?()
    }

    @objc func showCategories() {
        if splitViewController.isCollapsed {
            showCategoriesAction?()
        }
    }
}
