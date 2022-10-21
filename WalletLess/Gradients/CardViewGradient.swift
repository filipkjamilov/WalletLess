//  Created by Filip Kjamilov on 20.10.22.

import SwiftUI

public struct CardViewGradient: View {
    public var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(LinearGradient(colors: [Color.cyan.opacity(0.7), Color.purple.opacity(0.3)],
                                 startPoint: .topLeading,
                                 endPoint: .bottomTrailing))
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 120,
                   maxHeight: 120,
                   alignment: .topLeading)
            .shadow(color: Color.secondary, radius: 25, x: -10, y: 10)
    }
}
