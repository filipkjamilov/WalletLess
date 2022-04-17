//  Created by Filip Kjamilov on 27.2.22.

import SwiftUI

struct Settings: View {
    
    @Binding var tabSelection: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    SupportView()
                    LegalPolicyView()
                    AboutTheAppView()
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitle("Settings", displayMode: .large)
        }
    }
}

struct SupportView: View {
    var body: some View {
        Section(header: HStack {
            Image(systemName: "questionmark.circle")
            Text("Support")
            
        }) {
            HStack {
                Image(systemName: "book")
                NavigationLink(destination: UserManualView()) {
                    Text("User manual")
                }
            }
            HStack {
                Image(systemName: "phone")
                Link("Call us", destination: URL(string: "tel:+38978748743")!)
                    .buttonStyle(.plain)
            }
            HStack {
                Image(systemName: "envelope")
                Link("Email us", destination: URL(string: "mailto:support@walletless.com")!)
                    .buttonStyle(.plain)
            }
        }
        .headerProminence(.increased)
    }
}

struct LegalPolicyView: View {
    var body: some View {
        Section(header: HStack {
            Image(systemName: "shield.lefthalf.fill")
            Text("Legal Policy")
            
        }, footer: Text("For more legal policy please contact us.")) {
            HStack {
                Image(systemName: "doc.plaintext")
                NavigationLink(destination: TermsAndConditionView()) {
                    Text("Terms and conditions")
                }
            }
            HStack {
                Image(systemName: "lock.shield")
                NavigationLink(destination: PrivacyPolicyView()) {
                    Text("Privacy Policy")
                }
            }
        }
        .headerProminence(.increased)
    }
}

struct AboutTheAppView: View {
    
    let systemVersion = UIDevice.current.systemVersion
    let deviceName = UIDevice.current.name

    var body: some View {
        Section(header: HStack {
            Image(systemName: "exclamationmark.shield")
            Text("About the app")
            
        }, footer: HStack {
            Image(systemName: "r.circle")
            Text("All rights reserved")
        }) {
            HStack {
                Image(systemName: "bag")
                Text("Version: \(Bundle.main.appVersionLong)")
            }
            HStack {
                Image(systemName: "calendar.circle")
                Text("Last update: 17.04.2022")
            }
            HStack {
                Image(systemName: "aspectratio")
                Text("Device name: \(deviceName)")
            }
            HStack {
                Image(systemName: "square.and.pencil")
                Text("System version: \(systemVersion)")
            }
            HStack {
                Image(systemName: "signature")
                Text("Developed by: Filip Kjamilov")
            }
        }
        .headerProminence(.increased)
    }
}

struct UserManualView: View {
    var body: some View {
        VStack(spacing: 15) {
            // TODO: FKJ - Dummy text
            
            Text("Nullam nibh arcu, aliquam eu nisi ut, rutrum vulputate arcu. Vivamus vulputate mauris et erat finibus accumsan. Nam maximus magna dolor, ornare bibendum magna malesuada nec. Nulla facilisis, justo ut elementum euismod, eros sem luctus ante, aliquet ultrices ex est in diam.")

            Text("Integer tincidunt urna eu dictum blandit. Donec non nunc sit amet mi tincidunt faucibus. Praesent posuere magna sit amet nisi aliquet venenatis. Praesent felis tortor, pellentesque sed ipsum eu, vulputate vehicula elit. Aenean elementum non justo sit amet finibus. Duis porttitor tempus odio, nec vestibulum mi lacinia ut. Sed vel est suscipit, ultrices lectus vel, lobortis neque. Sed in lectus risus.")
            
            Text("Integer tincidunt urna eu dictum blandit. Donec non nunc sit amet mi tincidunt faucibus. Praesent posuere magna sit amet nisi aliquet venenatis. Praesent felis tortor, pellentesque sed ipsum eu, vulputate vehicula elit. Aenean elementum non justo sit amet finibus. Duis porttitor tempus odio, nec vestibulum mi lacinia ut. Sed vel est suscipit, ultrices lectus vel, lobortis neque. Sed in lectus risus.")
            
            Spacer()
        }
    }
}

struct TermsAndConditionView: View {
    var body: some View {
        Text("Integer tincidunt urna eu dictum blandit. Donec non nunc sit amet mi tincidunt faucibus. Praesent posuere magna sit amet nisi aliquet venenatis. Praesent felis tortor, pellentesque sed ipsum eu, vulputate vehicula elit. Aenean elementum non justo sit amet finibus. Duis porttitor tempus odio, nec vestibulum mi lacinia ut. Sed vel est suscipit, ultrices lectus vel, lobortis neque. Sed in lectus risus.")
        
        Spacer()
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        Text("Integer tincidunt urna eu dictum blandit. Donec non nunc sit amet mi tincidunt faucibus. Praesent posuere magna sit amet nisi aliquet venenatis. Praesent felis tortor, pellentesque sed ipsum eu, vulputate vehicula elit. Aenean elementum non justo sit amet finibus. Duis porttitor tempus odio, nec vestibulum mi lacinia ut. Sed vel est suscipit, ultrices lectus vel, lobortis neque. Sed in lectus risus.")
        
        Spacer()
    }
}

// TODO: FKJ - Move this in Bundle+Extensions
extension Bundle {
    public var appName: String { getInfo("CFBundleName")  }
    public var displayName: String {getInfo("CFBundleDisplayName")}
    public var language: String {getInfo("CFBundleDevelopmentRegion")}
    public var identifier: String {getInfo("CFBundleIdentifier")}
    public var copyright: String {getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }
    
    public var appBuild: String { getInfo("CFBundleVersion") }
    public var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(tabSelection: Binding.constant(3))
    }
}
