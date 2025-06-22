//
//  AppNavigationManager+Actions.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - Public Navigation Actions (الإجراءات العامة للتنقل)
extension AppNavigationManager {
    
    // MARK: - Completion Actions
    
    /// إكمال التعريف والانتقال للمرحلة التالية
    func completeOnboarding() {
        print("✅ تم إكمال التعريف")
        
        // تحديث حالة المستخدم
        UserDefaultsManager.hasCompletedOnboarding = true
        
        // تحديد الخطوة التالية
        if UserDefaultsManager.isLoggedIn {
            navigateToMain()
        } else {
            navigateToLogin()
        }
    }
    
    /// تسجيل دخول ناجح
    func loginSuccess(token: String, userId: String, userName: String? = nil) {
        print("🎉 تم تسجيل الدخول بنجاح")
        
        // حفظ بيانات المستخدم
        UserDefaultsManager.userToken = token
        UserDefaultsManager.userId = userId
        UserDefaultsManager.userName = userName
        
        // الانتقال للتطبيق الرئيسي
        navigateToMain()
    }
    
    /// تسجيل خروج
    func logout() {
        print("🚪 تم تسجيل الخروج")
        
        // مسح بيانات المستخدم
        UserDefaultsManager.logout()
        
        // الانتقال لتسجيل الدخول
        navigateToLogin()
    }
    
    // MARK: - Direct Navigation
    
    /// الانتقال للتطبيق الرئيسي
    func navigateToMain() {
        let mainViewController = createMainViewController()
        performTransition(to: mainViewController)
        print("🏠 تم الانتقال للتطبيق الرئيسي")
    }
    
    /// الانتقال لتسجيل الدخول
    func navigateToLogin() {
        let loginViewController = createLoginViewController()
        performTransition(to: loginViewController)
        print("🔐 تم الانتقال لتسجيل الدخول")
    }
    
    /// الانتقال لواجهة التعريف
    func navigateToOnboarding() {
        let onboardingViewController = createOnboardingViewController()
        performTransition(to: onboardingViewController)
        print("🎯 تم الانتقال لواجهة التعريف")
    }
    
    // MARK: - State Management
    
    /// إعادة تعيين التطبيق بالكامل
    func resetApp() {
        print("🔄 إعادة تعيين التطبيق")
        
        // مسح جميع البيانات
        UserDefaultsManager.resetAll()
        
        // العودة لواجهة التعريف
        navigateToOnboarding()
    }
    
    /// تحديث الواجهة الحالية
    func refreshCurrentState() {
        print("🔄 تحديث الواجهة الحالية")
        
        let currentViewController = determineInitialViewController()
        performTransition(to: currentViewController)
    }
}
