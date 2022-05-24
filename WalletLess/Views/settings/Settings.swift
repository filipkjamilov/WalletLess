//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI

struct Settings: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Binding var tabSelection: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    AppConfigurationView()
                    SupportView()
                    LegalPolicyView()
                    AboutTheAppView()
                }
                .listStyle(InsetGroupedListStyle())
                .background(
                    GradientBackground().ignoresSafeArea()
                )
                .onAppear {
                    // Set the default to clear
                    UITableView.appearance().backgroundColor = .clear
                }
            }
            .navigationBarTitle("Settings".localized(language), displayMode: .large)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(tabSelection: Binding.constant(3))
    }
}
