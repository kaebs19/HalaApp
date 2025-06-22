//
//  AppNavigationManager+Core.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - Core Navigation Logic (المنطق الأساسي للتنقل)
extension AppNavigationManager {
    
    /// تحديد الواجهة الأولى المناسبة
    internal func determineInitialViewController() -> UIViewController {
        
        let hasCompletedOnboarding = UserDefaultsManager.hasCompletedOnboarding
        let isLoggedIn = UserDefaultsManager.isLoggedIn
        
        print("📊 حالة التطبيق:")
        print("   - التعريف مكتمل: \(hasCompletedOnboarding ? "✅" : "❌")")
        print("   - مسجل دخول: \(isLoggedIn ? "✅" : "❌")")
        
        // منطق التحديد
        switch (hasCompletedOnboarding, isLoggedIn) {
        case (false, _):
            print("🎯 → عرض واجهة التعريف")
            return createOnboardingViewController()
            
        case (true, false):
            print("🔐 → عرض واجهة تسجيل الدخول")
            return createLoginViewController()
            
        case (true, true):
            print("🏠 → عرض التطبيق الرئيسي")
            return createMainViewController()
        }
    }
    
    /// إنشاء واجهة التعريف
    internal func createOnboardingViewController() -> UIViewController {
        guard let onboardingVC = loadFromStoryboard(.Onboarding, identifier: .Onboarding) else {
            fatalError("❌ لا يمكن تحميل واجهة التعريف من Storyboard")
        }
        return wrapInNavigationController(onboardingVC)
    }
    
    /// إنشاء واجهة تسجيل الدخول
    internal func createLoginViewController() -> UIViewController {
        guard let loginVC = loadFromStoryboard(.Auth, identifier: .Login) else {
            fatalError("❌ لا يمكن تحميل واجهة تسجيل الدخول من Storyboard")
        }
        return wrapInNavigationController(loginVC)
    }
    
    /// إنشاء الواجهة الرئيسية
    internal func createMainViewController() -> UIViewController {
        guard let mainVC = loadFromStoryboard(.Main, identifier: .Main) else {
            fatalError("❌ لا يمكن تحميل الواجهة الرئيسية من Storyboard")
        }
        return wrapInNavigationController(mainVC)
    }
    
    // MARK: - Helper Methods
    
    /// تحميل ViewController من Storyboard
    private func loadFromStoryboard(_ storyboard: Storyboards, identifier: Identifiers) -> UIViewController? {
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    /// لف ViewController في NavigationController
    private func wrapInNavigationController(_ viewController: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: viewController)
    }
    
    /// تنفيذ الانتقال مع تأثير بصري
    internal func performTransition(to viewController: UIViewController) {
        guard let window = currentWindow else { return }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = viewController
        }
    }
}
