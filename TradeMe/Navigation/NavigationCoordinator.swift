//  Created by Oleg Chernyshenko on 10/03/18.

import UIKit

protocol CategoryBrowserDelegate: class {
    func moveToCategory(id: Int, name: String)
    func updateCategory(id: Int, name: String)
    func movingBack(to categoryId: Int?)
}

class NavigationCoordinator: CategoryBrowserDelegate {
    typealias categoryUpdateCompletion = (SearchResult?) -> ()
    var categoryNavigation: UINavigationController?
    var listingsNavigation: UINavigationController?
    var splitViewController: UISplitViewController?

    var selectedCategoryId: Int = 0
    var currentCategoryId: Int?
    var networking = NetworkManagerImpl()

    func start() {
        moveToCategory(id: 0, name: "Category")
    }

    func moveToCategory(id: Int, name: String) {
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
    }

    func updateCategory(id: Int, name: String) {
        self.presentListings([])
        networking.getCategory(id) { [weak self] result in
            guard let result = result else {
                return
            }
            self?.presentListings(result.listings)
            self?.currentCategoryId = id
        }
    }

    func presentCategory() {
        let viewController = CategoryViewController()
        viewController.delegate = self
        let navigationButton = UIBarButtonItem(title: "Listings", style: .plain, target: self, action: #selector(self.showDetails))
        viewController.navigationItem.setRightBarButton(navigationButton, animated: true)
        categoryNavigation?.pushViewController(viewController, animated: true)
    }

    func updateCategory(_ model: CategoryModel) {
        if let viewController = categoryNavigation?.topViewController as? CategoryViewController {
            viewController.setModel(model)
        }
    }

    func presentListings(_ listings: [SearchResult.Listing]) {
        let viewController = ListingsViewController()
        viewController.listings = listings
        viewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        listingsNavigation?.viewControllers = [viewController]
        let navigationButton = UIBarButtonItem(title: "Show Categories", style: .plain, target: self, action: #selector(self.showCategories))
        viewController.navigationItem.setRightBarButton(navigationButton, animated: true)
    }

    func movingBack(to categoryId: Int?) {
        let viewController = categoryNavigation?.topViewController
        let title = viewController?.title ?? "General"
        let categoryId = categoryId ?? 0
        self.updateCategory(id: categoryId, name: title)
        print("Moving to: \(categoryId)")
    }

    @objc func showDetails() {
        splitViewController?.showDetailViewController(listingsNavigation!, sender: self)
    }

    @objc func showCategories() {
        if splitViewController!.isCollapsed {
            listingsNavigation!.navigationController?.popViewController(animated: true)
        }
    }
}

extension NavigationCoordinator: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        return listingsNavigation!
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        return true
    }
}
