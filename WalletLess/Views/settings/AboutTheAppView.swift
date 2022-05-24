//  Created by Filip Kjamilov on 24.5.22.

import SwiftUI

public struct AboutTheAppView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    let systemVersion = UIDevice.current.systemVersion
    let deviceName = UIDevice.current.name
    
    public var body: some View {
        Section(header: HStack {
            Image(systemName: "exclamationmark.shield")
            Text("About the app".localized(language))
            
        }, footer: HStack {
            Image(systemName: "r.circle")
            Text("All rights reserved".localized(language))
        }) {
            HStack {
                Image(systemName: "bag")
                Text("\("Version".localized(language)): \(Bundle.main.appVersionLong)")
            }
            HStack {
                Image(systemName: "calendar.circle")
                Text("\("Last update".localized(language)): 17.04.2022")
            }
            HStack {
                Image(systemName: "aspectratio")
                Text("\("Device name".localized(language)): \(deviceName)")
            }
            HStack {
                Image(systemName: "square.and.pencil")
                Text("\("System version".localized(language)): \(systemVersion)")
            }
            HStack {
                Image(systemName: "signature")
                Text("\("Developed by".localized(language)): Filip Kjamilov")
            }
        }
        .headerProminence(.increased)
        .listRowBackground(Color.primary.opacity(0.1))
    }
}
