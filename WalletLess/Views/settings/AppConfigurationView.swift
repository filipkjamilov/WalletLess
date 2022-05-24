//  Created by Filip Kjamilov on 24.5.22.

import SwiftUI

public struct AppConfigurationView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var selectedLanguage: Language = LocalizationService.shared.language
    
    public var body: some View {
        Section(header: HStack {
            Image(systemName: "slider.horizontal.3")
            Text("AppConfiguration".localized(language))
            
        }) {
            VStack {
                Section(header: Text("Language".localized(language))) {
                    Picker("Language", selection: $selectedLanguage.onChange(languageChanged)) {
                        Text("Macedonian".localized(language)).tag(Language.macedonian)
                        Text("English".localized(language)).tag(Language.english_us)
                        Text("Albanian".localized(language)).tag(Language.albanian)
                    }.pickerStyle(.segmented)
                }
                
            }
            
        }
        .headerProminence(.increased)
        .listRowBackground(Color.primary.opacity(0.1))
    }
    
    private func languageChanged(to language: Language) {
        LocalizationService.shared.language = language
    }
    
}
