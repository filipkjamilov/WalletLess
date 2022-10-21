//  Created by Filip Kjamilov on 21.10.22.

import SafariServices
import SwiftUI

public struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: URL

    public func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    public func updateUIViewController(_ uiViewController: SFSafariViewController,
                                       context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }
}
