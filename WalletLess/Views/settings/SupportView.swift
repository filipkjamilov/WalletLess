//  Created by Filip Kjamilov on 24.5.22.

import SwiftUI

public struct SupportView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var showSafari: Bool = false
    
    public var body: some View {
        Section(header: HStack {
            Image(systemName: "questionmark.circle")
            Text("Support".localized(language))
            
        }) {
            HStack {
                Image(systemName: "macwindow")
                Button("Visit us".localized(language)) {
                    showSafari.toggle()
                }
                    .buttonStyle(.plain)
            }
            HStack {
                Image(systemName: "envelope")
                Link("Email us".localized(language), destination: URL(string: "mailto:walletlessapp@gmail.com")!)
                    .buttonStyle(.plain)
            }
        }.fullScreenCover(isPresented: $showSafari, content: {
            SFSafariViewWrapper(url: URL(string: "https://www.walletlessapp.com")!)
        })
        .headerProminence(.increased)
        .listRowBackground(Color.primary.opacity(0.1))
    }
}
