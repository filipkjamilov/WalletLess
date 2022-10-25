//  Created by Filip Kjamilov on 18.10.22.

import SwiftUI

public struct GradientBackground: View {
    public var body: some View {
        ZStack {
            LinearGradient(colors: [Color.cyan.opacity(0.7), Color.purple.opacity(0.3)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            Circle()
                .frame(width: 300)
                .foregroundStyle(LinearGradient(colors: [Color.mint.opacity(0.5), Color.purple.opacity(0.6)],
                                                startPoint: .top,
                                                endPoint: .leading))
                .offset(x: -100, y: -150)
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .frame(width: 500, height: 500)
                .foregroundStyle(LinearGradient(colors: [Color.purple.opacity(0.6), Color.mint.opacity(0.5)],
                                                startPoint: .top,
                                                endPoint: .leading))
                .offset(x: 300)
                .rotationEffect(.degrees(30))
            
        }.ignoresSafeArea(.all)
    }
}
