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
        AppearanceManager.apply()
        return true
    }

    private func setupRootViewController() -> UISplitViewController {
        let splitViewController = UISplitViewController()
        splitViewController.delegate = coordinator
        let masterNavigator = UINavigationController()
        let detailNavigator = UINavigationController()
        splitViewController.viewControllers = [masterNavigator, detailNavigator]
//        splitViewController.preferredDisplayMode = .primaryHidden
        return splitViewController
    }

    private func setupNavigation(_ splitViewController: UISplitViewController) {
        coordinator.categoryNavigation = splitViewController.viewControllers[0] as? UINavigationController
        coordinator.listingsNavigation = splitViewController.viewControllers[1] as? UINavigationController
        coordinator.splitViewController = splitViewController
    }
}
