//  Created by Filip Kjamilov on 24.5.22.

import SwiftUI

public struct CardGradientBackground: View {
    public var body: some View {
        ZStack {
            LinearGradient(colors: [Color.cyan.opacity(0.7), Color.purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle()
                .frame(width: 120)
                .foregroundStyle(LinearGradient(colors: [Color.mint, Color.purple], startPoint: .top, endPoint: .leading))
                .offset(x: -150, y: -60)
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 200, height: 200)
                .foregroundStyle(LinearGradient(colors: [Color.purple.opacity(0.6), Color.mint.opacity(0.5)], startPoint: .top, endPoint: .leading))
                .offset(x: 180, y: -120)
                .rotationEffect(.degrees(35))
            
        }.ignoresSafeArea(.all)
    }
}
