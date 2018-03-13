//  Created by Oleg Chernyshenko on 10/03/18.

import UIKit

protocol CategoryBrowserDelegate: class {
    func showCategory(_ category: SearchResult.Category)
    func movingBack(to categoryId: Int?)
}

protocol ListingBrowserDelegate: class {
    func showListing(_ listing: SearchResult.Listing)
}

class NavigationCoordinator: CategoryBrowserDelegate {
    typealias categoryUpdateCompletion = (SearchResult?) -> ()
    var categoryNavigation: UINavigationController?
    var listingsNavigation: UINavigationController?
    var splitViewController: UISplitViewController?

    var currentCategoryId: Int?
    var networking = NetworkManagerImpl()
    var navigationUIManager: SplitNavigationUIManager?

    func start() {
        setupSplitNavigationUIManager()
        moveToCategory(id: 0, name: "Category")
    }

    private func setupSplitNavigationUIManager() {
        navigationUIManager = SplitNavigationUIManager(with: splitViewController!,
                                                       listingsNavigation: listingsNavigation!,
                                                       categoryNavigation: categoryNavigation!)
        navigationUIManager?.showCategoriesAction = { self.showCategories() }
        navigationUIManager?.showListingsAction = { self.showListings() }
    }

    func showCategory(_ category: SearchResult.Category) {
        if category.hasSubcategory {
            moveToCategory(id: category.categoryId, name: category.name)
        } else {
            updateListings(for: category.categoryId, name: category.name)
        }
    }

    private func moveToCategory(id: Int, name: String) {
        self.presentCategory()
        networking.getCategory(id) { [weak self] result in
            guard let result = result else {
                return
            }
            let model = CategoryModel(categories: result.categories,
                                      name: name,
                                      id: id,
                                      parentCategoryId: self?.currentCategoryId)
            self?.updateCategory(model)

            self?.presentListings(result.listings)
            self?.currentCategoryId = id
        }
        navigationUIManager?.showNavigationButtonsIfNeeded()
    }

    private func updateListings(for categoryId: Int, name: String) {
        self.presentListings([])
        networking.getCategory(categoryId) { [weak self] result in
            guard let result = result else {
                return
            }
            self?.presentListings(result.listings)
            self?.currentCategoryId = categoryId
        }
        navigationUIManager?.showNavigationButtonsIfNeeded()
    }

    private func presentCategory() {
        let viewController = CategoryViewController()
        viewController.delegate = self
        categoryNavigation?.pushViewController(viewController, animated: true)
    }

    private func updateCategory(_ model: CategoryModel) {
        if let viewController = categoryNavigation?.topViewController as? CategoryViewController {
            viewController.setModel(model)
        }
    }

    private func presentListings(_ listings: [SearchResult.Listing]) {
        let viewController = ListingsViewController()
        viewController.delegate = self
        viewController.imageLoader = self.networking
        viewController.listings = listings
        viewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        listingsNavigation?.viewControllers = [viewController]
        navigationUIManager?.showNavigationButtonsIfNeeded()
    }

    func movingBack(to categoryId: Int?) {
        let viewController = categoryNavigation?.topViewController
        let title = viewController?.title ?? "General"
        let categoryId = categoryId ?? 0
        self.updateListings(for: categoryId, name: title)
    }

    // MARK: - Compact width navigation
    func showListings() {
        splitViewController!.showDetailViewController(listingsNavigation!, sender: self)
        navigationUIManager?.showNavigationButtonsIfNeeded()
    }

    func showCategories() {
        if splitViewController!.isCollapsed {
            listingsNavigation!.navigationController?.popViewController(animated: true)
        }
    }
}

extension NavigationCoordinator: ListingBrowserDelegate {
    func showListing(_ listing: SearchResult.Listing) {
        let listingViewController = ListingDetailsViewController(with: listing)
        listingViewController.listingLoader = self.networking
        listingViewController.imageLoader = self.networking
        
        listingViewController.title = listing.title
        listingsNavigation?.pushViewController(listingViewController, animated: true)
    }
}

extension NavigationCoordinator: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        navigationUIManager?.removeNavigationButtons()
        return listingsNavigation!
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        listingsNavigation?.popToRootViewController(animated: true)
        navigationUIManager?.addNavigationButtons()
        return true
    }
}
