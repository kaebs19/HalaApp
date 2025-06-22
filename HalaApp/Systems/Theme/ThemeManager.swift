//
//  ThemeManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

class ThemeManager: NSObject {
   
    
    // MARK: - Singleton

    static let shared = ThemeManager()
    private override init() {}
    
    
    // MARK: - Properties

    var currentTheme: ThemeMode  {
        get {
            return UserDefaultsManager.themeMode
        }
        set {
            UserDefaultsManager.themeMode = newValue
            applyTheme(newValue)
            notifyThemeChange(newValue)
        }
    }
    
    /// التحقق من الوضع المظلم الحالي
    var isDarkModeActive: Bool {
        guard let window = getCurrentWindow() else {
            return false
        }
        return window.traitCollection.userInterfaceStyle == .dark
        
    }
    
    // MARK: - Theme Application
    /// تطبيق الثيم المحدد مع انتقال سلس

    func applyTheme(_ mode: ThemeMode, animated: Bool = true) {
        
        guard let window = getCurrentWindow() else {
            print("❌ لا يمكن الوصول للنافذة لتطبيق الثيم")
            return
        }
        
        let applyChanges = {
            window.overrideUserInterfaceStyle = mode.userInterfaceStyle
        }
        
        if animated {
            UIView.transition(with: window, duration: 0.3,
                            options: .transitionCrossDissolve,
                            animations: applyChanges)
        } else {
            applyChanges()
        }
        
        print("🎨 تم تطبيق الثيم: \(mode.displayName)")

    }

    /// تطبيق الثيم المحفوظ عند بدء التطبيق
    func applyStoredTheme() {
        applyTheme(currentTheme , animated: false)
        print("💾 تم تطبيق الثيم المحفوظ: \(currentTheme.displayName)")
    }
    
    // MARK: - Theme Management
    /// تغيير الثيم مع إشعار المراقبين
    func changeTheme(to mode: ThemeMode , animated: Bool = true) {
        guard mode != currentTheme else {
            print("⚠️ الثيم المطلوب مطبق بالفعل")
            return
        }
        
        currentTheme = mode
        // تطبيق فوري إذا لم يتم التطبيق من خلال setter
        applyTheme(mode , animated: animated)
    }
    
    /// التنقل بين الثيمز
    func toggleTheme() {
         let allThemes = ThemeMode.allCases
         let currentIndex = allThemes.firstIndex(of: currentTheme) ?? 0
         let nextIndex = (currentIndex + 1) % allThemes.count
         let nextTheme = allThemes[nextIndex]
         
         changeTheme(to: nextTheme, animated: true)
         
         print("🔄 تم التنقل للثيم: \(nextTheme.displayName)")
     }
    
    // MARK: - Notifications
    /// إرسال إشعار بتغيير الثيم
    private func notifyThemeChange(_ newTheme: ThemeMode) {
        NotificationCenter.default.post(name: .themeDidChange,
                                        object: newTheme,
                                        userInfo:  ["previousTheme": currentTheme])
    }
    
    /// بدء مراقبة تغييرات النظام
    func startSystemThemeObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(systemThemeChanged),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        print("👀 تم بدء مراقبة تغييرات ثيم النظام")
    }

    @objc private func systemThemeChanged() {
        if currentTheme == .auto {
            applyTheme(.auto, animated: false)
            print("🔄 تم تحديث الثيم التلقائي")
        }
    }
    
    // MARK: - Helper Methods
    /// الحصول على النافذة الحالية
    private func getCurrentWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows.first
        } else {
            return UIApplication.shared.windows.first
        }
    }

    /// الحصول على جميع الثيمز المتاحة

    func getAllThemes() -> [ThemeMode] {
        return ThemeMode.allCases
    }
    
    
    /// إعادة تعيين الثيم للافتراضي
    func resetToDefaultTheme() {
        changeTheme(to: .auto, animated: true)
        print("🔄 تم إعادة تعيين الثيم للافتراضي")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - ThemeMode Enum
extension ThemeManager {
    
    /// أنواع الثيمز المتاحة
        enum ThemeMode: Int, CaseIterable {
            case auto = 0   // تلقائي حسب النظام
            case light = 1  // فاتح
            case dark = 2   // مظلم
            
            /// تحويل لـ UIUserInterfaceStyle
            var userInterfaceStyle: UIUserInterfaceStyle {
                switch self {
                case .auto: return .unspecified
                case .light: return .light
                case .dark: return .dark
                }
            }
            
            /// الاسم المعروض
            var displayName: String {
                switch self {
                    case .auto: return LanguageManager.shared.isEnglish() ? "Auto" : "تلقائي"
                    case .light: return LanguageManager.shared.isEnglish() ? "Light" : "فاتح"
                    case .dark: return LanguageManager.shared.isEnglish() ? "Dark" : "مظلم"
                }
            }
            
            /// أيقونة الثيم
            var iconName: String {
                switch self {
                case .auto: return "circle.lefthalf.filled"
                case .light: return "sun.max"
                case .dark: return "moon"
                }
            }
            
            /// وصف الثيم
            var description: String {
                switch self {
                    case .auto:
                        return LanguageManager.shared.isEnglish() ? "Mode Always Auto" : "يتبع إعدادات الجهاز"
                case .light:
                        return LanguageManager.shared.isEnglish() ? "Mode Always Light" : "وضع فاتح دائماً"
                    case .dark: 
                        return LanguageManager.shared.isEnglish() ? "Mode Always Dark" : "وضع مظلم دائماً"
                }
            }
        }
}
