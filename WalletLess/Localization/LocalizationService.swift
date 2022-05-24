//  Created by Filip Kjamilov on 23.5.22.

import SwiftUI

public enum Language: String, CaseIterable, Identifiable, Equatable {
    case macedonian = "mk-MK"
    case albanian = "sq"
    case english_us = "en"
    public var id: Self { self }
}

public class LocalizationService {
    
    static let shared = LocalizationService()
    static let changedLanguage = Notification.Name("changedLanguage")
    
    private init() {}
    
    var language: Language {
        get {
            guard let languageString = UserDefaults.standard.string(forKey: "language") else {
                return .english_us
            }
            return Language(rawValue: languageString) ?? .english_us
        } set {
            if newValue != language {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: "language")
                NotificationCenter.default.post(name: LocalizationService.changedLanguage, object: nil)
            }
        }
    }
}
