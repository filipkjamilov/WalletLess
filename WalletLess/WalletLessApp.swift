//  Created by Filip Kjamilov on 4.11.21.

import SwiftUI
import Firebase

@main
struct WalletLessApp: App {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    // TODO: FKJ - [FEATURE] - Implement better switching between views
    /// Have a enum where you can chose between .dashboard, .merchant, .settings
    @State private var tabSelection = 1
    let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
    let navigationBarAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
    
    init() {
        FirebaseApp.configure()
        // TODO: FKJ - Only works for Firebase Database
        // For ussage of Storage the data will not be persisted!
        Database.database().isPersistenceEnabled = true
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().backgroundColor = UIColor(Color.secondary)
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = UIColor(Color.secondary.opacity(0.7))
        // TODO: FKJ - Workaround for iOS: 16
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UICollectionView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                TabView(selection: $tabSelection) {
                    Dashboard(tabSelection: $tabSelection)
                        .tabItem() {
                            Image(systemName: "creditcard")
                            Text("Dashboard".localized(language))
                        }
                        .tag(1)
                    Merchants(tabSelection: $tabSelection)
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
}
