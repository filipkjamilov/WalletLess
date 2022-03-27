//  Created by Filip Kjamilov on 4.11.21.

import SwiftUI

struct ContentView: View {
    
    @StateObject var realmManager = RealmManager()
    
    var body: some View {
        ZStack {
            TabView {
                Dashboard()
                    .environmentObject(realmManager)
                    .tabItem() {
                        Image(systemName: "creditcard")
                        Text("Dashboard")
                    }
                Merchants()
                    .environmentObject(realmManager)
                    .tabItem() {
                        Image(systemName: "plus.square")
                        Text("Merchants")
                    }
                Settings()
                    .tabItem() {
                        Image(systemName: "slider.horizontal.3")
                        Text("Settings")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
