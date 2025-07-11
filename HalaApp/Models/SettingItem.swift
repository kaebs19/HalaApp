//
//  SettingItem.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 11/07/2025.
//

import UIKit

struct SettingItem {
    let icon: AppImage
    let title: SettingTitle
    let subtitle: String?
    let switchVisible: Bool
    let switchOn: Bool
    let actionType: SettingsActionType
    let tintColor: AppColors
    
    // خاصية مساعدة للتحقق من وجود Segmented Control
    var hasSegmentedControl: Bool {
        if case .segmented = actionType {
            return true
        }
        return false
    }
}

// MARK: - Settings Section Model
struct SettingsSection {
    let title: String?
    let items: [SettingItem]
    let footerText: String?
}

enum SettingsActionType {
    case navigate
    case toggle
    case segmented
    case custom((SettingsVC) -> Void)
}

enum SettingTitle {
    case account
    case message
    case notification
    case appearance
    case announcements
    case helpCenter
    case privacy
    case aboutUs
    case language
    
    var titleName: String {
        switch self {
        case .account:
            return LanguageManager.shared.isEnglish() ? "Account Settings" : "إعدادات الحساب"
        case .message:
            return LanguageManager.shared.isEnglish() ? "Messaging" : "الرسائل"
        case .notification:
            return LanguageManager.shared.isEnglish() ? "Notifications" : "الإشعارات"
        case .appearance:
            return LanguageManager.shared.isEnglish() ? "Appearance" : "المظهر"
        case .announcements:
            return LanguageManager.shared.isEnglish() ? "Announcements" : "الإعلانات"
        case .helpCenter:
            return LanguageManager.shared.isEnglish() ? "Help Center" : "مركز المساعدة"
        case .privacy:
            return LanguageManager.shared.isEnglish() ? "Privacy" : "الخصوصية"
        case .aboutUs:
            return LanguageManager.shared.isEnglish() ? "About Hala Chat App" : "حول التطبيق"
        case .language:
            return LanguageManager.shared.isEnglish() ? "Language" : "اللغة"
        }
    }
}

class SettingsDataManager {
    static let shared = SettingsDataManager()
    private init() {}
    
    // ✅ إصلاح: إرجاع [SettingsSection] وليس [SettingItem]
    func getAllSections() -> [SettingsSection] {
        return [
            // القسم الأول - الحساب والتطبيق
            SettingsSection(
                title: nil,
                items: [
                    SettingItem(
                        icon: .AccountSettings,
                        title: .account,
                        subtitle: nil,
                        switchVisible: false,
                        switchOn: false,
                        actionType: .navigate,
                        tintColor: .text
                    ),
                    SettingItem(
                        icon: .notification,
                        title: .notification,
                        subtitle: nil,
                        switchVisible: true,
                        switchOn: true,
                        actionType: .toggle,
                        tintColor: .text
                    ),
                    SettingItem(
                        icon: .Message,
                        title: .message,
                        subtitle: nil,
                        switchVisible: false,
                        switchOn: false,
                        actionType: .navigate,
                        tintColor: .text
                    ),
                    SettingItem(
                        icon: .Appearance,
                        title: .appearance,
                        subtitle: nil,
                        switchVisible: false,
                        switchOn: false,
                        actionType: .segmented,
                        tintColor: .text
                    )
                ],
                footerText: nil
            ),
            
            // القسم الثاني - المساعدة والمعلومات
            SettingsSection(
                title: nil,
                items: [
                    SettingItem(
                        icon: .Annoucement,
                        title: .announcements,
                        subtitle: nil,
                        switchVisible: false,
                        switchOn: false,
                        actionType: .navigate,
                        tintColor: .text
                    ),
                    SettingItem(
                        icon: .Helpcenter,
                        title: .helpCenter,
                        subtitle: nil,
                        switchVisible: false,
                        switchOn: false,
                        actionType: .navigate,
                        tintColor: .text
                    ),
                    SettingItem(
                        icon: .Privacy,
                        title: .privacy,
                        subtitle: nil,
                        switchVisible: false,
                        switchOn: false,
                        actionType: .navigate,
                        tintColor: .text
                    ),
                    SettingItem(
                        icon: .Info,
                        title: .aboutUs,
                        subtitle: nil,
                        switchVisible: false,
                        switchOn: false,
                        actionType: .navigate,
                        tintColor: .text
                    )
                ],
                footerText: nil
            ),
            
            // القسم الثالث - إعدادات شخصية
            SettingsSection(
                title: nil,
                items: [
                    SettingItem(
                        icon: .Language,
                        title: .language,
                        subtitle: nil,
                        switchVisible: false,
                        switchOn: false,
                        actionType: .segmented,
                        tintColor: .text
                    )
                ],
                footerText: nil
            )
        ]
    }
    
    // ✅ للتوافق مع الكود القديم
    func getAllSettings() -> [SettingItem] {
        return getAllSections().flatMap { $0.items }
    }
}

