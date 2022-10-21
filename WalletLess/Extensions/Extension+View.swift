//  Created by Filip Kjamilov on 21.10.22.

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    
    @State private var didLoad = false
    
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)?) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if !didLoad {
                didLoad = true
                action?()
            }
        }
    }
    
}

extension View {
    
    // Custom modifier for checking if the view did load.
    func viewDidLoad(perform action: (() -> Void)?) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
    
}
