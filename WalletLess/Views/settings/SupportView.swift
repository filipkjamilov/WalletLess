//  Created by Filip Kjamilov on 24.5.22.

import SwiftUI

public struct SupportView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    public var body: some View {
        Section(header: HStack {
            Image(systemName: "questionmark.circle")
            Text("Support".localized(language))
            
        }) {
//            HStack {
//                Image(systemName: "book")
//                NavigationLink(destination: UserManualView()) {
//                    Text("User manual".localized(language))
//                }
//            }
            HStack {
                Image(systemName: "phone")
                Link("Call us".localized(language), destination: URL(string: "tel:+38978748743")!)
                    .buttonStyle(.plain)
            }
            HStack {
                Image(systemName: "envelope")
                Link("Email us".localized(language), destination: URL(string: "mailto:walletlessapp@gmail.com")!)
                    .buttonStyle(.plain)
            }
        }
        .headerProminence(.increased)
        .listRowBackground(Color.primary.opacity(0.1))
    }
}
