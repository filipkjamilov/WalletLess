//  Created by Filip Kjamilov on 20.10.22.

import SwiftUI

struct AlertViewGradient: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(LinearGradient(colors: [Color.pink.opacity(0.8), Color.red.opacity(0.4)],
                                 startPoint: .topLeading,
                                 endPoint: .bottomTrailing))
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 100,
                   maxHeight: 100,
                   alignment: .topLeading)
            .shadow(color: Color.secondary, radius: 25, x: -10, y: 10)
    }
}
