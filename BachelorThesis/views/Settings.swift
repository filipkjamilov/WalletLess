//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI

struct Settings: View {
    
    @Binding var tabSelection: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section(header: HStack {
                        Image(systemName: "questionmark.circle")
                        Text("Support")
                        
                    }) {
                        HStack {
                            Image(systemName: "book")
                            Text("User manual")
                        }
                        HStack {
                            Image(systemName: "phone")
                            Text("Call us")
                        }
                        HStack {
                            Image(systemName: "envelope")
                            Text("Email us")
                        }
                    }
                    .headerProminence(.increased)
                    
                    Section(header: HStack {
                        Image(systemName: "shield.lefthalf.fill")
                        Text("Legal Policy")
                        
                    }, footer: Text("For more legal policy please contact us.")) {
                        HStack {
                            Image(systemName: "doc.plaintext")
                            Text("Terms and conditions")
                        }
                        HStack {
                            Image(systemName: "lock.shield")
                            Text("Privacy Policy")
                        }
                    }
                    .headerProminence(.increased)
                    
                    Section(header: HStack {
                        Image(systemName: "exclamationmark.shield")
                        Text("About the app")
                        
                    }, footer: HStack {
                        Image(systemName: "r.circle")
                        Text("All rights reserved")
                    }) {
                        HStack {
                            Image(systemName: "bag")
                            Text("Version: 0.0.0")
                        }
                        HStack {
                            Image(systemName: "calendar.circle")
                            Text("Last update: 17.04.2022")
                        }
                        HStack {
                            Image(systemName: "square.and.pencil")
                            Text("Developed by: Filip Kjamilov")
                        }
                    }
                    .headerProminence(.increased)
                }
                .listStyle(InsetGroupedListStyle())
                
            }
            .navigationBarTitle("Settings", displayMode: .large)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(tabSelection: Binding.constant(3))
    }
}
