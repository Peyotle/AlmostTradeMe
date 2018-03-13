//  Created by Oleg Chernyshenko on 13/03/18.

import Foundation
import BRYXBanner

class ErrorPresenter {
    static func present(error: Error) {
        DispatchQueue.main.async {
            let title = error.localizedDescription
            let banner = Banner(title: title,
                                subtitle: nil,
                                image: nil,
                                backgroundColor: .red)
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
        }
    }
}
