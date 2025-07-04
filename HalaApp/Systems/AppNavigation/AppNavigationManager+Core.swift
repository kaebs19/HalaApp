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
    /// إنشاء الواجهة الرئيسية عبر الكود

    internal func createMainViewController() -> UIViewController {
        // إنشاء TabBar Controller
        // إنشاء TabBar Controller برمجياً (ليس من Storyboard)
            let tabBarController = MainTabBars()
            
            // إنشاء ViewControllers من Storyboards المنفصلة
            let homeVC = createViewController(from: .Main, identifier: .Home)
            let messagesVC = createViewController(from: .Main, identifier: .Messages)
            let notificationsVC = createViewController(from: .Main, identifier: .Notifications)
            let accountVC = createViewController(from: .Main, identifier: .Acounts)
            
            // لف كل ViewController في NavigationController
            let homeNav = createNavigationController(rootViewController: homeVC)
            let messagesNav = createNavigationController(rootViewController: messagesVC)
            let notificationsNav = createNavigationController(rootViewController: notificationsVC)
            let accountNav = createNavigationController(rootViewController: accountVC)
            
            // تعيين ViewControllers للـ TabBar
            tabBarController.viewControllers = [homeNav, messagesNav, notificationsNav, accountNav]
            
            print("✅ تم إنشاء MainViewController مع \(tabBarController.viewControllers?.count ?? 0) ViewControllers")
            
            return tabBarController

    }
    
    /// إنشاء ViewController من Storyboard
      private func createViewController(from storyboard: Storyboards, identifier: Identifiers) -> UIViewController {
          let storyboardInstance = UIStoryboard(name: storyboard.rawValue, bundle: nil)
          let viewController = storyboardInstance.instantiateViewController(withIdentifier: identifier.rawValue)
          return viewController
      }
      
      /// إنشاء NavigationController
      private func createNavigationController(rootViewController: UIViewController) -> UINavigationController {
          let navController = UINavigationController(rootViewController: rootViewController)
          // إزالة أي TabBarItem موجود
          navController.tabBarItem = nil
          return navController
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
