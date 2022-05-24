//  Created by Filip Kjamilov on 24.5.22.

import SwiftUI

public struct LegalPolicyView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    public var body: some View {
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
