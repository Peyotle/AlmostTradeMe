//  Created by Oleg Chernyshenko on 9/03/18.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let coordinator = NavigationCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootViewController = setupRootViewController()
        setupNavigation(rootViewController)
        coordinator.start()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }

    private func setupRootViewController() -> UISplitViewController {
        let splitViewController = UISplitViewController()
        splitViewController.delegate = self
        let masterNavigator = UINavigationController()
        let detailNavigator = UINavigationController()
        splitViewController.viewControllers = [masterNavigator, detailNavigator]
        return splitViewController
    }

    private func setupNavigation(_ splitViewController: UISplitViewController) {
        coordinator.categoryNavigation = splitViewController.viewControllers[0] as! UINavigationController
        coordinator.listingsNavigation = splitViewController.viewControllers[1] as! UINavigationController
        coordinator.splitViewController = splitViewController
    }
}

extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? ListingsViewController else { return false }
        if topAsDetailController.listings.count == 0 {
            return true
        }
        return false
    }
}

