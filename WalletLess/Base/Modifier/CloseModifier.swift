//  Created by Filip Kjamilov on 8.8.22.

import SwiftUI

struct CloseModifier: ViewModifier {
    
    @Environment(\.presentationMode) var presentationMode

    func body(content: Content) -> some View {
        content
            .toolbar {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                })
            }
    }
    
}

extension View {
    
    // Add close button on toolbar
    func applyCloseButton() -> some View {
        self.modifier(CloseModifier())
    }
}
