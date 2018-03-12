//  Created by Oleg Chernyshenko on 12/03/18.

import UIKit

struct AppearanceManager {
    static func apply() {
        UINavigationBar.appearance().barTintColor = UIColor.tradeMeHeaderBase
        UINavigationBar.appearance().tintColor = UIColor.tradeMeHeaderInteractive
    }
}
