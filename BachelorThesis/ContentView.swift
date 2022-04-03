//  Created by Filip Kjamilov on 4.11.21.

import SwiftUI

struct ContentView: View {
    
    @StateObject var realmManager = RealmManager()
    @State private var tabSelection = 1
    
    var body: some View {
        ZStack {
            TabView(selection: $tabSelection) {
                Dashboard(tabSelection: $tabSelection)
                    .environmentObject(realmManager)
                    .tabItem() {
                        Image(systemName: "creditcard")
                        Text("Dashboard")
                    }
                    .tag(1)
                Merchants(tabSelection: $tabSelection)
                    .environmentObject(realmManager)
                    .tabItem() {
                        Image(systemName: "plus.square")
                        Text("Merchants")
                    }
                    .tag(2)
                Settings(tabSelection: $tabSelection)
                    .tabItem() {
                        Image(systemName: "slider.horizontal.3")
                        Text("Settings")
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
