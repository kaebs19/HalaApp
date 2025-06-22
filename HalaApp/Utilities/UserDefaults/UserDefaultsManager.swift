//
//  UserDefaultsManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import Foundation

/// مدير حفظ البيانات المحلية - بسيط ومرن وسهل الاستخدام
final class UserDefaultsManager {
    
    // MARK: - Singleton
    static let shared = UserDefaultsManager()
    private init() {}
    
    // MARK: - 🔐 User Authentication
    
    /// حالة إكمال التعريف بالتطبيق
    @UserDefault("has_completed_onboarding", defaultValue: false)
    static var hasCompletedOnboarding: Bool
    
    /// رمز المستخدم المميز
    @UserDefault("user_token", defaultValue: nil)
    static var userToken: String?
    
    /// معرف المستخدم
    @UserDefault("user_id", defaultValue: nil)
    static var userId: String?
    
    /// اسم المستخدم
    @UserDefault("user_name", defaultValue: nil)
    static var userName: String?
    
    /// التحقق من تسجيل دخول المستخدم
    static var isLoggedIn: Bool {
        return userToken != nil && !userToken!.isEmpty
    }
    
    // MARK: - ⚙️ App Settings
    
    /// وضع الثيم (فاتح/داكن/تلقائي)
    @UserDefault("app_theme_mode", defaultValue: 0)
    static var appThemeMode: Int

    
    /// وضع الثيم مع دعم ThemeManager.ThemeMode
    static var themeMode: ThemeManager.ThemeMode {
        get {
            return ThemeManager.ThemeMode(rawValue: appThemeMode) ?? .auto
        }
        set {
            appThemeMode = newValue.rawValue
        }
    }
    
    /// لغة التطبيق
    @UserDefault("user_language", defaultValue: "ar")
    static var userLanguage: String
    
    /// حجم الخط
    @UserDefault("font_size", defaultValue: 16.0)
    static var fontSize: Float
    
    /// حالة الإشعارات
    @UserDefault("notifications_enabled", defaultValue: true)
    static var notificationsEnabled: Bool
    
    // MARK: - 🎮 Interaction Settings
    
    /// الاهتزاز التفاعلي
    @UserDefault("haptic_enabled", defaultValue: true)
    static var hapticEnabled: Bool
    
    /// الأصوات
    @UserDefault("sound_enabled", defaultValue: true)
    static var soundEnabled: Bool
    
    /// الانيميشن
    @UserDefault("animation_enabled", defaultValue: true)
    static var animationEnabled: Bool
    
    /// حالة "تذكرني" في تسجيل الدخول
    @UserDefault("remember_me", defaultValue: false)
    static var rememberMe: Bool

    
    // MARK: - 🎯 Quick Actions
    
    /// تسجيل دخول المستخدم
    static func saveUserLogin(token: String, userId: String, userName: String? = nil) {
        self.userToken = token
        self.userId = userId
        self.userName = userName
        print("✅ تم حفظ بيانات المستخدم")
    }
    
    /// تسجيل خروج المستخدم
    static func logout() {
        userToken = nil
        userId = nil
        userName = nil
        print("🚪 تم تسجيل خروج المستخدم")
    }
    
    /// إكمال التعريف
    static func completeOnboarding() {
        hasCompletedOnboarding = true
        print("🎯 تم إكمال التعريف")
    }
    
    // MARK: - 🧹 Reset Methods
    
    /// إعادة تعيين بيانات المستخدم فقط
    static func resetUserData() {
        userToken = nil
        userId = nil
        userName = nil
        print("🗑️ تم مسح بيانات المستخدم")
    }
    
    /// إعادة تعيين حالة التطبيق للبداية
    static func resetAppState() {
        hasCompletedOnboarding = false
        resetUserData()
        print("🔄 تم إعادة تعيين حالة التطبيق")
    }
    
    /// إعادة تعيين الإعدادات للافتراضية
    static func resetSettings() {
        appThemeMode = 0
        userLanguage = "ar"
        fontSize = 16.0
        notificationsEnabled = true
        hapticEnabled = true
        soundEnabled = true
        animationEnabled = true
        print("⚙️ تم إعادة تعيين الإعدادات")
    }
    
    /// إعادة تعيين كل شيء
    static func resetAll() {
        resetAppState()
        resetSettings()
        print("🆕 تم إعادة تعيين التطبيق بالكامل")
    }
}

// MARK: - 🛠️ Property Wrapper للبساطة والأمان
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

// MARK: - 📚 دليل الاستخدام السريع
/*
 
 🎯 كيفية الاستخدام:
 ==================
 
 1️⃣ حفظ واسترجاع البيانات:
 ---------------------------
 
 // تسجيل دخول المستخدم
 UserDefaultsManager.saveUserLogin(
     token: "abc123",
     userId: "user456",
     userName: "أحمد محمد"
 )
 
 // التحقق من تسجيل الدخول
 if UserDefaultsManager.isLoggedIn {
     print("المستخدم مسجل دخول")
 }
 
 // الحصول على بيانات المستخدم
 let token = UserDefaultsManager.userToken
 let userId = UserDefaultsManager.userId
 let userName = UserDefaultsManager.userName
 
 2️⃣ إدارة حالة التطبيق:
 ---------------------
 
 // إكمال التعريف
 UserDefaultsManager.completeOnboarding()
 
 // التحقق من إكمال التعريف
 if UserDefaultsManager.hasCompletedOnboarding {
     // إظهار الشاشة الرئيسية
 }
 
 3️⃣ إعدادات التطبيق:
 ------------------
 
 // تغيير الثيم
 UserDefaultsManager.appThemeMode = 1 // 0: تلقائي، 1: فاتح، 2: داكن
 
 // تغيير اللغة
 UserDefaultsManager.userLanguage = "en"
 
 // إعدادات التفاعل
 UserDefaultsManager.hapticEnabled = false
 UserDefaultsManager.soundEnabled = true
 
 4️⃣ عمليات الإعادة والمسح:
 -------------------------
 
 // تسجيل خروج
 UserDefaultsManager.logout()
 
 // إعادة تعيين التطبيق
 UserDefaultsManager.resetAppState()
 
 // إعادة تعيين الإعدادات
 UserDefaultsManager.resetSettings()
 
 // إعادة تعيين كل شيء
 UserDefaultsManager.resetAll()
 
 ⚡ مثال كامل:
 =============
 
 // في تطبيقك
 class LoginViewController: UIViewController {
     
     @IBAction func loginButtonTapped() {
         // محاكاة تسجيل دخول ناجح
         UserDefaultsManager.saveUserLogin(
             token: "xyz789",
             userId: "12345",
             userName: "سارة أحمد"
         )
         
         // الانتقال للشاشة الرئيسية
         if UserDefaultsManager.isLoggedIn {
             navigateToMainScreen()
         }
     }
     
     @IBAction func logoutButtonTapped() {
         UserDefaultsManager.logout()
         navigateToLoginScreen()
     }
 }
 
 // في إعدادات التطبيق
 class SettingsViewController: UIViewController {
     
     @IBOutlet weak var hapticSwitch: UISwitch!
     @IBOutlet weak var soundSwitch: UISwitch!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         // تحميل الإعدادات الحالية
         hapticSwitch.isOn = UserDefaultsManager.hapticEnabled
         soundSwitch.isOn = UserDefaultsManager.soundEnabled
     }
     
     @IBAction func hapticSwitchChanged(_ sender: UISwitch) {
         UserDefaultsManager.hapticEnabled = sender.isOn
     }
     
     @IBAction func soundSwitchChanged(_ sender: UISwitch) {
         UserDefaultsManager.soundEnabled = sender.isOn
     }
 }
 
 ⚠️ نصائح مهمة:
 ==============
 
 ✅ البيانات تُحفظ تلقائياً عند التغيير
 ✅ لا تحتاج لاستدعاء synchronize() يدوياً
 ✅ القيم الافتراضية محددة مسبقاً
 ✅ آمن من الأخطاء - لن يعطي nil غير متوقع
 ✅ بسيط ومباشر في الاستخدام
 
 🚫 تجنب:
 ========
 
 ❌ لا تستخدم UserDefaults مباشرة
 ❌ لا تحفظ كلمات المرور في UserDefaults
 ❌ لا تحفظ بيانات حساسة هنا
 
 */
