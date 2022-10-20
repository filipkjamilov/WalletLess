//  Created by Filip Kjamilov on 18.10.22.

import SwiftUI

// TODO: FKJ - Workaround for iOS: 16
extension UICollectionReusableView {
    override open var backgroundColor: UIColor? {
        get { .clear }
        set { }
    }
}
