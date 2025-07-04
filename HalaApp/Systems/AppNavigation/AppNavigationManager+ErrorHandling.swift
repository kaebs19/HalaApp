//
//  AppNavigationManager+ErrorHandling.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - Error Handling & Validation
extension AppNavigationManager {
    
    // MARK: - Validation Methods
    
    /// التحقق من صحة Storyboards والمعرفات
    internal func validateStoryboards() -> Bool {
        var isValid = true
        
        // التحقق من واجهة التعريف
        if loadFromStoryboard(.Onboarding, identifier: .Onboarding) == nil {
            print("❌ خطأ: لا يمكن تحميل واجهة التعريف")
            isValid = false
        }
        
        // التحقق من واجهة تسجيل الدخول
        if loadFromStoryboard(.Auth, identifier: .Login) == nil {
            print("❌ خطأ: لا يمكن تحميل واجهة تسجيل الدخول")
            isValid = false
        }
        
        // التحقق من ViewControllers الرئيسية
        let mainViewControllers = [
            ("Home", Identifiers.Home),
            ("Messages", Identifiers.Messages),
            ("Notifications", Identifiers.Notifications),
            ("Account", Identifiers.Acounts)
        ]
        
        for (name, identifier) in mainViewControllers {
            if loadFromStoryboard(.Main, identifier: identifier) == nil {
                print("❌ خطأ: لا يمكن تحميل \(name) ViewController")
                isValid = false
            }
        }
        
        if isValid {
            print("✅ جميع Storyboards صحيحة")
        }
        
        return isValid
    }
    
    /// التحقق من النافذة الحالية
    internal func validateWindow() -> Bool {
        guard currentWindow != nil else {
            print("❌ خطأ: لا يمكن الوصول للنافذة الرئيسية")
            return false
        }
        
        print("✅ النافذة الرئيسية متاحة")
        return true
    }
    
    // MARK: - Safe Navigation
    
    /// تنفيذ التنقل مع معالجة الأخطاء
    internal func safePerformTransition(to viewController: UIViewController) {
        guard validateWindow() else {
            print("❌ فشل التنقل: النافذة غير متاحة")
            return
        }
        
        performTransition(to: viewController)
    }
    
    /// إعداد آمن للواجهة الأولى
    func safeSetupInitialViewController() {
        guard validateWindow() else {
            print("❌ فشل الإعداد: النافذة غير متاحة")
            return
        }
        
        guard validateStoryboards() else {
            print("❌ فشل الإعداد: مشكلة في Storyboards")
            return
        }
        
        setupInitialViewController()
    }
    
    // MARK: - Debug Methods
    
    /// طباعة حالة النظام للتشخيص
    func debugSystemState() {
        print("🔍 حالة النظام:")
        print("================")
        print("النافذة: \(currentWindow != nil ? "✅" : "❌")")
        print("التعريف مكتمل: \(UserDefaultsManager.hasCompletedOnboarding ? "✅" : "❌")")
        print("مسجل دخول: \(UserDefaultsManager.isLoggedIn ? "✅" : "❌")")
        print("رمز المستخدم: \(UserDefaultsManager.userToken ?? "غير موجود")")
        print("معرف المستخدم: \(UserDefaultsManager.userId ?? "غير موجود")")
        print("================")
    }
    
    /// اختبار جميع واجهات Storyboard
    func testAllViewControllers() {
        print("🧪 اختبار جميع واجهات Storyboard:")
        print("==================================")
        
        // اختبار واجهات التطبيق الأساسية
        let tests: [(String, () -> UIViewController?)] = [
            ("التعريف", { self.loadFromStoryboard(.Onboarding, identifier: .Onboarding) }),
            ("تسجيل الدخول", { self.loadFromStoryboard(.Auth, identifier: .Login) }),
            ("الصفحة الرئيسية", { self.loadFromStoryboard(.Main, identifier: .Home) }),
            ("الرسائل", { self.loadFromStoryboard(.Main, identifier: .Messages) }),
            ("الإشعارات", { self.loadFromStoryboard(.Main, identifier: .Notifications) }),
            ("الحساب", { self.loadFromStoryboard(.Main, identifier: .Acounts) })
        ]
        
        for (name, test) in tests {
            if test() != nil {
                print("✅ \(name): متاح")
            } else {
                print("❌ \(name): غير متاح")
            }
        }
        
        // اختبار إنشاء MainTabBars برمجياً
        print("🔧 اختبار MainTabBars:")
        let tabBar = MainTabBars()
        print("✅ MainTabBars: تم إنشاؤه برمجياً")
        
        print("==================================")
    }
    
    // MARK: - Helper Methods
    
    /// تحميل ViewController من Storyboard
    private func loadFromStoryboard(_ storyboard: Storyboards, identifier: Identifiers) -> UIViewController? {
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
