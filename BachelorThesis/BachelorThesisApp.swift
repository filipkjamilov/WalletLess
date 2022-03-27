//  Created by Filip Kjamilov on 4.11.21.

import SwiftUI
import Firebase

@main
struct BachelorThesisApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
