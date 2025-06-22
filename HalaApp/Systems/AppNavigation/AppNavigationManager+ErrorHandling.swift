//
//  AppNavigationManager+ErrorHandling.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - Error Handling & Validation (معالجة الأخطاء والتحقق)
extension AppNavigationManager {
    
    // MARK: - Validation Methods
    /// تحميل ViewController من Storyboard
    private func loadFromStoryboard(_ storyboard: Storyboards, identifier: Identifiers) -> UIViewController? {
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

    /// التحقق من صحة Storyboard والمعرفات
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
        
        // التحقق من الواجهة الرئيسية
        if loadFromStoryboard(.Main, identifier: .Main) == nil {
            print("❌ خطأ: لا يمكن تحميل الواجهة الرئيسية")
            isValid = false
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
        
        let tests = [
            ("التعريف", { self.loadFromStoryboard(.Onboarding, identifier: .Onboarding) }),
            ("تسجيل الدخول", { self.loadFromStoryboard(.Auth, identifier: .Login) }),
            ("الرئيسية", { self.loadFromStoryboard(.Main, identifier: .Main) })
        ]
        
        for (name, test) in tests {
            if test() != nil {
                print("✅ \(name): متاح")
            } else {
                print("❌ \(name): غير متاح")
            }
        }
        
        print("==================================")
    }
}
