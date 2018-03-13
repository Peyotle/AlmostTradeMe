//  Created by Oleg Chernyshenko on 9/03/18.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: NavigationCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootViewController = setupRootViewController()
        coordinator = NavigationCoordinator(with: rootViewController)
        coordinator.start()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        Appearance.apply()
        return true
    }

    private func setupRootViewController() -> UISplitViewController {
        let splitViewController = UISplitViewController()
        let masterNavigator = UINavigationController()
        let detailNavigator = UINavigationController()
        splitViewController.viewControllers = [masterNavigator, detailNavigator]
        splitViewController.preferredDisplayMode = .allVisible
        return splitViewController
    }
}
