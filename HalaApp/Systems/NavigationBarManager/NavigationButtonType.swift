//
//  NavigationButtonType.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 20/06/2025.
//

import UIKit

// MARK: - Navigation Button Types
enum NavigationButtonType: Equatable, Hashable {
    case back(showTitle: Bool = false)
    case close(showTitle: Bool = false)
    case custom(icon: String, title: String? = nil)
    case menu(showTitle: Bool = false)
    case more(showTitle: Bool = false)
    case done(showTitle: Bool = false)
    case cancel(showTitle: Bool = false)
    case next(showTitle: Bool = false)
    case save(showTitle: Bool = false)
    case notificaiton(showTitle: Bool = false)
    case search(showTitle: Bool = false)
    case info(showTitle: Bool = false)
    case help(showTitle: Bool = false)
    case skip(showTitle: Bool = false)
    
    // MARK: - Icon Configuration
    var iconName: String {
        switch self {
        case .back:
            return LanguageManager.shared.isEnglish() ? "chevron.left" : "chevron.right"
        case .close:
            return Images.close.imageName
        case .custom(let icon, _):
            return icon
        case .menu:
            return Images.menu.imageName
        case .more:
            return Images.morefill.imageName
        case .done:
            return "checkmark"
        case .cancel:
            return "xmark"
        case .next:
            return LanguageManager.shared.isEnglish() ? "chevron.right" : "chevron.left"
        case .save:
            return Images.save.imageName
        case .notificaiton:
            return Images.notification.imageName
        case .search:
            return Images.search.imageName
        case .info:
            return "info.circle"
        case .help:
            return "questionmark.circle"
        case .skip:
            return "forward.fill"
        }
    }
    
    var title: String? {
        switch self {
        case .back(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "Back" : "عودة") : nil
        case .close(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "Close" : "إغلاق") : nil
        case .custom(_, let title):
            return title
        case .menu(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "Menu" : "القائمة") : nil
        case .more(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "More" : "المزيد") : nil
        case .done(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "Done" : "إنهاء") : nil
        case .cancel(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "Cancel" : "الغاء") : nil
        case .next(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "Next" : "التالي") : nil
        case .save(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "Save" : "حفظ") : nil
        case .notificaiton(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "Notifications" : "الإشعارات") : nil
        case .search(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "Search" : "بحث") : nil
        case .info(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "Info" : "معلومات") : nil
        case .help(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "Help" : "مساعدة") : nil
        case .skip(let showTitle):
            return showTitle ? (LanguageManager.shared.isEnglish() ? "Skip" : "تخطي") : nil
        }
    }
    
    /// تحديد هل يستخدم صورة من Assets أم من النظام
    var isSystemIcon: Bool {
        switch self {
        case .done, .cancel, .info, .help, .skip:
            return true
        case .back, .next:
            return true // سنستخدم أيقونات النظام للاتجاهات
        default:
            return false
        }
    }
    
    /// تحديد موقع الزر الافتراضي (يسار أم يمين)
    var defaultPosition: NavigationButtonPosition {
        switch self {
        case .back, .close, .menu:
            return .left
        default:
            return .right
        }
    }
    
    /// اسم الدالة الافتراضية للزر
    var defaultFunctionName: String {
        switch self {
        case .back:
            return "handleBackButton"
        case .close:
            return "handleCloseButton"
        case .menu:
            return "handleMenuButton"
        case .more:
            return "handleMoreButton"
        case .done:
            return "handleDoneButton"
        case .cancel:
            return "handleCancelButton"
        case .next:
            return "handleNextButton"
        case .save:
            return "handleSaveButton"
        case .notificaiton:
            return "handleNotificationButton"
        case .search:
            return "handleSearchButton"
        case .info:
            return "handleInfoButton"
        case .help:
            return "handleHelpButton"
        case .skip:
            return "handleSkipButton"
        case .custom(_, _):
            return "handleCustomButton"
        }
    }
}

// MARK: - Button Position
enum NavigationButtonPosition {
    case left
    case right
}

// MARK: - Equatable & Hashable Implementation
extension NavigationButtonType {
    static func == (lhs: NavigationButtonType, rhs: NavigationButtonType) -> Bool {
        switch (lhs, rhs) {
        case (.back(let showTitle1), .back(let showTitle2)):
            return showTitle1 == showTitle2
        case (.close(let showTitle1), .close(let showTitle2)):
            return showTitle1 == showTitle2
        case (.menu(let showTitle1), .menu(let showTitle2)):
            return showTitle1 == showTitle2
        case (.more(let showTitle1), .more(let showTitle2)):
            return showTitle1 == showTitle2
        case (.done(let showTitle1), .done(let showTitle2)):
            return showTitle1 == showTitle2
        case (.cancel(let showTitle1), .cancel(let showTitle2)):
            return showTitle1 == showTitle2
        case (.next(let showTitle1), .next(let showTitle2)):
            return showTitle1 == showTitle2
        case (.save(let showTitle1), .save(let showTitle2)):
            return showTitle1 == showTitle2
        case (.notificaiton(let showTitle1), .notificaiton(let showTitle2)):
            return showTitle1 == showTitle2
        case (.search(let showTitle1), .search(let showTitle2)):
            return showTitle1 == showTitle2
        case (.info(let showTitle1), .info(let showTitle2)):
            return showTitle1 == showTitle2
        case (.help(let showTitle1), .help(let showTitle2)):
            return showTitle1 == showTitle2
        case (.skip(let showTitle1), .skip(let showTitle2)):
            return showTitle1 == showTitle2
        case (.custom(let icon1, let title1), .custom(let icon2, let title2)):
            return icon1 == icon2 && title1 == title2
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .back(let showTitle):
            hasher.combine("back")
            hasher.combine(showTitle)
        case .close(let showTitle):
            hasher.combine("close")
            hasher.combine(showTitle)
        case .custom(let icon, let title):
            hasher.combine("custom")
            hasher.combine(icon)
            hasher.combine(title)
        case .menu(let showTitle):
            hasher.combine("menu")
            hasher.combine(showTitle)
        case .more(let showTitle):
            hasher.combine("more")
            hasher.combine(showTitle)
        case .done(let showTitle):
            hasher.combine("done")
            hasher.combine(showTitle)
        case .cancel(let showTitle):
            hasher.combine("cancel")
            hasher.combine(showTitle)
        case .next(let showTitle):
            hasher.combine("next")
            hasher.combine(showTitle)
        case .save(let showTitle):
            hasher.combine("save")
            hasher.combine(showTitle)
        case .notificaiton(let showTitle):
            hasher.combine("notification")
            hasher.combine(showTitle)
        case .search(let showTitle):
            hasher.combine("search")
            hasher.combine(showTitle)
        case .info(let showTitle):
            hasher.combine("info")
            hasher.combine(showTitle)
        case .help(let showTitle):
            hasher.combine("help")
            hasher.combine(showTitle)
        case .skip(let showTitle):
            hasher.combine("skip")
            hasher.combine(showTitle)
        }
    }
}
