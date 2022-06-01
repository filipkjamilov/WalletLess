//  Created by Filip Kjamilov on 4.11.21.

import SwiftUI

struct ContentView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @StateObject var realmManager = RealmManager()
    // TODO: FKJ - [FEATURE] - Implement better switching between views
    /// Have a enum where you can chose between .dashboard, .merchant, .settings
    @State private var tabSelection = 1
    let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
    let navigationBarAppearance: UINavigationBarAppearance = UINavigationBarAppearance()

    init() {
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().backgroundColor = UIColor(Color.secondary)
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = UIColor(Color.secondary.opacity(0.7))
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $tabSelection) {
                Dashboard(tabSelection: $tabSelection)
                    .environmentObject(realmManager)
                    .tabItem() {
                        Image(systemName: "creditcard")
                        Text("Dashboard".localized(language))
                    }
                    .tag(1)
                Merchants(tabSelection: $tabSelection)
                    .environmentObject(realmManager)
                    .tabItem() {
                        Image(systemName: "plus.square")
                        Text("Merchants".localized(language))
                    }
                    .tag(2)
                Settings(tabSelection: $tabSelection)
                    .tabItem() {
                        Image(systemName: "slider.horizontal.3")
                        Text("Settings".localized(language))
                    }
                    .tag(3)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
