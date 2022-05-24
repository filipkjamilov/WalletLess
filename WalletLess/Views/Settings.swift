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
                    AppConfiguration()
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

struct AppConfiguration: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var selectedLanguage: Language = .english_us
    
    var body: some View {
        Section(header: HStack {
            Image(systemName: "slider.horizontal.3")
            Text("AppConfiguration".localized(language))
            
        }) {
            HStack {
                Picker("Language", selection: $selectedLanguage.onChange(languageChanged)) {
                    Text("Macedonian".localized(language)).tag(Language.macedonian)
                    Text("English".localized(language)).tag(Language.english_us)
                    Text("Albanian".localized(language)).tag(Language.albanian)
                }.pickerStyle(.segmented)
            }
            
        }
        .headerProminence(.increased)
        .listRowBackground(Color.primary.opacity(0.1))
    }
    
    private func languageChanged(to language: Language) {
        LocalizationService.shared.language = language
    }
    
}

struct SupportView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var body: some View {
        Section(header: HStack {
            Image(systemName: "questionmark.circle")
            Text("Support".localized(language))
            
        }) {
            HStack {
                Image(systemName: "book")
                NavigationLink(destination: UserManualView()) {
                    Text("User manual".localized(language))
                }
            }
            HStack {
                Image(systemName: "phone")
                Link("Call us".localized(language), destination: URL(string: "tel:+38978748743")!)
                    .buttonStyle(.plain)
            }
            HStack {
                Image(systemName: "envelope")
                Link("Email us".localized(language), destination: URL(string: "mailto:support@walletless.com")!)
                    .buttonStyle(.plain)
            }
        }
        .headerProminence(.increased)
        .listRowBackground(Color.primary.opacity(0.1))
    }
}

struct LegalPolicyView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var body: some View {
        Section(header: HStack {
            Image(systemName: "shield.lefthalf.fill")
            Text("Legal Policy".localized(language))
            
        }, footer: Text("LegalPolicyFooter".localized(language))) {
            HStack {
                Image(systemName: "doc.plaintext")
                NavigationLink(destination: TermsAndConditionView()) {
                    Text("Terms and conditions".localized(language))
                }
            }
            HStack {
                Image(systemName: "lock.shield")
                NavigationLink(destination: PrivacyPolicyView()) {
                    Text("Privacy Policy".localized(language))
                }
            }
        }
        .headerProminence(.increased)
        .listRowBackground(Color.primary.opacity(0.1))
    }
}

struct AboutTheAppView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    let systemVersion = UIDevice.current.systemVersion
    let deviceName = UIDevice.current.name
    
    var body: some View {
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

struct UserManualView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
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
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var body: some View {
        Text("Integer tincidunt urna eu dictum blandit. Donec non nunc sit amet mi tincidunt faucibus. Praesent posuere magna sit amet nisi aliquet venenatis. Praesent felis tortor, pellentesque sed ipsum eu, vulputate vehicula elit. Aenean elementum non justo sit amet finibus. Duis porttitor tempus odio, nec vestibulum mi lacinia ut. Sed vel est suscipit, ultrices lectus vel, lobortis neque. Sed in lectus risus.")
        
        Spacer()
    }
}

struct PrivacyPolicyView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var body: some View {
        Text("Integer tincidunt urna eu dictum blandit. Donec non nunc sit amet mi tincidunt faucibus. Praesent posuere magna sit amet nisi aliquet venenatis. Praesent felis tortor, pellentesque sed ipsum eu, vulputate vehicula elit. Aenean elementum non justo sit amet finibus. Duis porttitor tempus odio, nec vestibulum mi lacinia ut. Sed vel est suscipit, ultrices lectus vel, lobortis neque. Sed in lectus risus.")
        
        Spacer()
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(tabSelection: Binding.constant(3))
    }
}
