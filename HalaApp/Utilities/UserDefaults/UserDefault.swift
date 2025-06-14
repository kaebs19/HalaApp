//
//  UserDefault.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import Foundation
import UIKit


class UserDefault: NSObject {
    
    static let shared = UserDefault()
    
    private override init() {}
    
    let defaults = UserDefaults.standard
    
    // MARK: - Keys
    private enum Keys {
        
        // إعدادات التطبيق الأساسية
        
        static let appThemeMode = "app_theme_mode"
        static let isFirstLaunch = "is_first_launch"
        static let userLanguage = "user_language"
        static let notificationsEnabled = "notifications_enabled"
        static let fontSize = "font_size"
        
        static let hasCompletedOnboarding = "has_completed_onboarding"
        static let userToken = "user_token"
        static let userId = "user_id"
        static let userName = "user_name"
        
        // إعدادات التفاعل والاهتزاز
        static let hapticEnabled = "haptic_enabled"
        static let soundEnabled = "sound_enabled"
        static let animationEnabled = "animation_enabled"
        
        
    }
    
    // MARK: - Properties
    
    /// التحقق من إكمال التعريف بالتطبيق
    var hasCompletedOnboarding: Bool {
        get {
            return defaults.bool(forKey: "has_completed_onboarding")
        }
        set {
            defaults.set(newValue, forKey: "has_completed_onboarding")
            defaults.synchronize()
        }
    }
    
    /// التحقق من تسجيل دخول المستخدم
    var isLoggedIn: Bool {
        get {
            return userToken != nil && !userToken!.isEmpty
        }
    }
    
    /// رمز المستخدم المميز
    var userToken: String? {
        get {
            return defaults.string(forKey: "user_token")
        }
        set {
            defaults.set(newValue, forKey: "user_token")
            defaults.synchronize()
        }
    }
    
    /// معرف المستخدم
    var userId: String? {
        get {
            return defaults.string(forKey: "user_id")
        }
        
        set {
            defaults.set(newValue, forKey: "user_id")
            defaults.synchronize()
        }
    }
    
    /// معلومات المستخدم الأساسية
    var userName: String? {
        get {
            return defaults.string(forKey: "user_name")
        }
        set {
            defaults.set(newValue, forKey: "user_name")
            defaults.synchronize()
        }
    }
    
    /// إعدادات الاهتزاز التفاعلي
    var hapticEnabled: Bool {
        get {
            // القيمة الافتراضية true إذا لم يتم تعيينها من قبل
            if defaults.object(forKey: Keys.hapticEnabled) == nil {
                return true
            }
            return defaults.bool(forKey: Keys.hapticEnabled)
        }
        set {
            defaults.set(newValue, forKey: Keys.hapticEnabled)
            defaults.synchronize()
            
            // إشعار التطبيق بتغيير الإعدادات
            NotificationCenter.default.post(
                name: .hapticSettingsChanged,
                object: newValue
            )
        }
    }
    
    /// إعدادات الأصوات
    var soundEnabled: Bool {
        get {
            if defaults.object(forKey: Keys.soundEnabled) == nil {
                return true
            }
            return defaults.bool(forKey: Keys.soundEnabled)
        }
        set {
            defaults.set(newValue, forKey: Keys.soundEnabled)
            defaults.synchronize()
        }
    }
    
    /// إعدادات الانيميشن
    var animationEnabled: Bool {
        get {
            if defaults.object(forKey: Keys.animationEnabled) == nil {
                return true
            }
            return defaults.bool(forKey: Keys.animationEnabled)
        }
        set {
            defaults.set(newValue, forKey: Keys.animationEnabled)
            defaults.synchronize()
        }
    }
    
    
    /// تسجيل خروج المستخدم
    func logoutUser() {
        userToken = nil
        userId = nil
        userName = nil
        
        print("🚪 تم تسجيل خروج المستخدم")
    }
    
    /// التحقق من تسجيل دخول المستخدم (مثال)
    func isUserLoggedIn() -> Bool {
        // منطق التحقق من تسجيل الدخول
        return UserDefault.shared.getStoredData(key: "user_token") != nil
    }
    
    
    /// إعدادات الثيم المحفوظة
    var appThemeMode: ThemeManager.ThemeMode {
        get {
            let rawValue = defaults.integer(forKey: Keys.appThemeMode)
            return ThemeManager.ThemeMode(rawValue: rawValue) ?? .auto
            
        } set {
            defaults.set(newValue, forKey: Keys.appThemeMode)
            defaults.synchronize()
        }
    }
    
    // MARK: - App Settings
    /// التحقق من أول تشغيل للتطبيق
    var isFirstLaunch: Bool {
        get {
            // إذا لم يتم تعيين القيمة من قبل، فهو أول تشغيل
            return !defaults.bool(forKey: Keys.isFirstLaunch)
        }
        set {
            defaults.set(!newValue, forKey: Keys.isFirstLaunch)
            defaults.synchronize()
        }
    }
    
    /// لغة التطبيق المحفوظة
    var userLanguage : String {
        get {
            return defaults.string(forKey: Keys.userLanguage) ?? "ar"
        }
        set {
            defaults.set(newValue, forKey: Keys.userLanguage)
            defaults.synchronize()
        }
    }
    
    /// إعدادات الإشعارات
    var notificationsEnabled: Bool {
        get {
            return defaults.bool(forKey: Keys.notificationsEnabled)
        }
        set {
            defaults.set(newValue, forKey: Keys.notificationsEnabled)
            defaults.synchronize()
        }
    }
    
    /// حجم الخط المفضل
    var fontSize: Float {
        get {
            let size = defaults.float(forKey: Keys.fontSize)
            return size == 0 ? 16.0 : size // القيمة الافتراضية
        }
        set {
            defaults.set(newValue, forKey: Keys.fontSize)
            defaults.synchronize()
        }
    }
    
    // MARK: - Generic Get/Set Methods
    /// الحصول على البيانات المحفوظة بشكل عام
    func getStoredData(key: String) -> Any? {
        switch key {
            case Keys.appThemeMode:
                return self.appThemeMode
            case Keys.isFirstLaunch:
                return self.isFirstLaunch
            case Keys.userLanguage:
                return self.userLanguage
            case Keys.notificationsEnabled:
                return self.notificationsEnabled
            case Keys.fontSize:
                return self.fontSize
            case Keys.hapticEnabled:
                return self.hapticEnabled
            case Keys.soundEnabled:
                return self.soundEnabled
            case Keys.animationEnabled:
                return self.animationEnabled
                
            default:
                return defaults.object(forKey: key)
        }
    }
    
    /// حفظ البيانات بشكل عام
    func setData(_ value: Any?, forKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    // MARK: - Reset Methods
    /// إعادة تعيين جميع الإعدادات
    func resetAllSettings() {
        
        let keys = [
            Keys.appThemeMode , Keys.isFirstLaunch, Keys.userLanguage, Keys.notificationsEnabled, Keys.fontSize,
            Keys.hapticEnabled
        ]
        keys.forEach { defaults.removeObject(forKey: $0) }
        defaults.synchronize()
        print("🗑️ تم إعادة تعيين جميع الإعدادات")
        
    }
    
    /// إعادة تعيين إعدادات الثيم فقط
    func resetThemeSettings() {
        defaults.removeObject(forKey: Keys.appThemeMode)
        defaults.synchronize()
        
        print("🎨 تم إعادة تعيين إعدادات الثيم")
        
    }
    /// إعادة تعيين إعدادات التفاعل
    func resetInteractionSettings() {
        let interactionKeys = [
            Keys.hapticEnabled, Keys.soundEnabled,
            Keys.animationEnabled
        ]
        
        
        /// إعادة تعيين حالة التطبيق للبداية
        func resetAppState() {
            hasCompletedOnboarding = false
            logoutUser()
            
            print("🔄 تم إعادة تعيين حالة التطبيق")
        }
        
    }
}
