//
//  Accounts.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 09/07/2025.
//

import UIKit


// MARK: - Account Data Manager
class AccountDataManager  {
    
    static let shared = AccountDataManager()
    private init() {}
    
    func getAllItems() -> [AccountItem] {
        return [
                    AccountItem(type: .subscriptions, icon: .Subscriptions),
                    AccountItem(type: .nearby, icon: .NearbyFriends),
                    AccountItem(type: .shareProfile, icon: .SharePrifile),
                    AccountItem(type: .favorites, icon: .Favorites),
                    AccountItem(type: .settings, icon: .Setting)
                ]

    }
    
}


struct AccountItem {
    let id: String = UUID().uuidString
    let type: AccountType
    let icon: AppImage
    let isEnabled: Bool
    let badgeCount: Int?
    let hasNavigation: Bool
    
    init(type: AccountType,
         icon: AppImage,
         isEnabled: Bool = true,
         badgeCount: Int? = nil,
         hasNavigation: Bool = true) {
        self.type = type
        self.icon = icon
        self.isEnabled = isEnabled
        self.badgeCount = badgeCount
        self.hasNavigation = hasNavigation
    }
}

enum AccountType: String, CaseIterable {
    case subscriptions = "Subscriptions"
    case nearby = "Nearby"
    case favorites = "Favorites"
    case shareProfile = "ShareProfile"
    case settings = "Settings"
    
    var displayName: String {
        switch self {
        case .subscriptions:
            return LanguageManager.shared.isEnglish() ? "Subscriptions" : "الاشتراكات"
        case .nearby:
            return LanguageManager.shared.isEnglish() ? "People Nearby" : "الأشخاص القريبون"
        case .favorites:
            return LanguageManager.shared.isEnglish() ? "My Wallet" : "محفظتي"
        case .shareProfile:
            return LanguageManager.shared.isEnglish() ? "My QR Code" : "رمز QR الخاص بي"
        case .settings:
            return LanguageManager.shared.isEnglish() ? "Settings" : "الإعدادات"
        }
    }
    
    var iconColor: AppColors {
        switch self {
        case .subscriptions:
            return .primary
        case .nearby:
            return .accent
        case .favorites:
            return .secondary
        case .shareProfile:
            return .primary
        case .settings:
            return .text
        }
    }
}
