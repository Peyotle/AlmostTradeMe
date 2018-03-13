//  Created by Oleg Chernyshenko on 10/03/18.

import UIKit

protocol CategoryBrowserDelegate: class {
    func moveToCategory(_ category: Category)
    func movingBack()
    func reload()
}

protocol ListingBrowserDelegate: class {
    func showListing(_ listing: SearchResult.Listing)
}

class NavigationCoordinator: CategoryBrowserDelegate {
    typealias categoryUpdateCompletion = (SearchResult?) -> ()
    var categoryNavigation: UINavigationController
    var listingsNavigation: UINavigationController
    var splitViewController: UISplitViewController
    var navigationStack: [Category] = []
    var networking = NetworkManagerImpl()
    var navigationUIManager: SplitNavigationUIManager

    init(with splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
        categoryNavigation = splitViewController.viewControllers[0] as! UINavigationController
        listingsNavigation = splitViewController.viewControllers[1] as! UINavigationController
        navigationUIManager = SplitNavigationUIManager(with: splitViewController,
                                                       listingsNavigation: listingsNavigation,
                                                       categoryNavigation: categoryNavigation)
        navigationUIManager.showCategoriesAction = { self.showCategories() }
        navigationUIManager.showListingsAction = { self.showListings() }
        self.splitViewController.delegate = self
    }

    func start() {
        presentCategoryController()
        loadCategory("0")
    }

    func reload() {
        let currentCategory = navigationStack.last?.number ?? "0"
        loadCategory(currentCategory)
    }

    func moveToCategory(_ category: Category) {
        if category.hasSubcategory {
            presentCategoryController()
            loadCategory(category.number)
        } else {
            loadListings(for: category)
        }
    }

    private func loadCategory(_ number: String) {
        networking.getCategory(number) { [weak self] category in
            guard let category = category else {
                return
            }
            self?.updateCategory(category)
            self?.loadListings(for: category)
        }
        navigationUIManager.showNavigationButtonsIfNeeded()
    }

    private func loadListings(for category: Category) {
        self.presentListingsController([], categoryName: category.name)
        networking.getListings(category.number) { [weak self] result in
            guard let result = result else {
                return
            }
            self?.presentListingsController(result.listings, categoryName: category.name)
        }
        navigationUIManager.showNavigationButtonsIfNeeded()
    }

    private func presentCategoryController() {
        let viewController = CategoryViewController()
        viewController.delegate = self
        categoryNavigation.pushViewController(viewController, animated: true)
    }

    private func updateCategory(_ model: Category) {
        if navigationStack.last?.number != model.number {
            navigationStack.append(model)
        }
        if let viewController = categoryNavigation.topViewController as? CategoryViewController {
            viewController.setModel(model)
        }
    }

    private func presentListingsController(_ listings: [SearchResult.Listing], categoryName: String) {
        let viewController = ListingsViewController()
        viewController.delegate = self
        viewController.imageLoader = self.networking
        viewController.listings = listings
        viewController.title = categoryName
        viewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        listingsNavigation.viewControllers = [viewController]
        navigationUIManager.showNavigationButtonsIfNeeded()
    }

    func movingBack() {
        guard let category = navigationStack.popLast() else { return }
        loadListings(for: category)
    }

    // MARK: - Compact width navigation
    func showListings() {
        splitViewController.showDetailViewController(listingsNavigation, sender: self)
        navigationUIManager.showNavigationButtonsIfNeeded()
    }

    func showCategories() {
        if splitViewController.isCollapsed {
            listingsNavigation.navigationController?.popViewController(animated: true)
        }
    }
}

extension NavigationCoordinator: ListingBrowserDelegate {
    func showListing(_ listing: SearchResult.Listing) {
        let listingViewController = ListingDetailsViewController(with: listing)
        listingViewController.listingLoader = self.networking
        listingViewController.imageLoader = self.networking
        
        listingViewController.title = listing.title
        listingsNavigation.pushViewController(listingViewController, animated: true)
    }
}

extension NavigationCoordinator: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        navigationUIManager.removeNavigationButtons()
        return listingsNavigation
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        listingsNavigation.popToRootViewController(animated: true)
        navigationUIManager.addNavigationButtons()
        return true
    }
}
