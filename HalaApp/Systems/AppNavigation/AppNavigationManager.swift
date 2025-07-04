//
//  AppNavigationManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

/// مدير التنقل في التطبيق - يتولى جميع عمليات التنقل الأساسية
final class AppNavigationManager {
    
    // MARK: - Singleton
    static let shared = AppNavigationManager()
    private init() {}
    private weak var window: UIWindow?

    
    // MARK: - Properties
    
    var currentWindow: UIWindow? {
        return window
    }

    
    // MARK: - Main Setup
    /// إعداد الواجهة الأولى للتطبيق
    func setupInitialViewController() {
        guard let window = currentWindow else {
            print("❌ لا يمكن الوصول للنافذة")
            return
        }
        
        let targetViewController = determineInitialViewController()
        
        window.rootViewController = targetViewController
        window.makeKeyAndVisible()
        
        print("✅ تم عرض الواجهة: \(String(describing: type(of: targetViewController)))")
    }
    
    func setCurrentWindow(_ window: UIWindow?) {
        self.window = window
    }
}

// MARK: - 📚 دليل الاستخدام السريع
/*
 
 🎯 كيفية الاستخدام:
 ==================
 
 1️⃣ الإعداد الأولي (في SceneDelegate أو AppDelegate):
 ---------------------------------------------------
 AppNavigationManager.shared.setupInitialViewController()
 
 2️⃣ إكمال التعريف:
 -----------------
 AppNavigationManager.shared.completeOnboarding()
 
 3️⃣ تسجيل دخول ناجح:
 --------------------
 AppNavigationManager.shared.loginSuccess(
     token: "user_token",
     userId: "user_id",
     userName: "اسم المستخدم"
 )
 
 4️⃣ تسجيل خروج:
 ---------------
 AppNavigationManager.shared.logout()
 
 5️⃣ التنقل المباشر:
 -----------------
 AppNavigationManager.shared.navigateToMain()
 AppNavigationManager.shared.navigateToLogin()
 AppNavigationManager.shared.navigateToOnboarding()
 
 6️⃣ الإعداد الآمن والتشخيص:
 --------------------------
 AppNavigationManager.shared.safeSetupInitialViewController()
 AppNavigationManager.shared.debugSystemState()
 AppNavigationManager.shared.testAllViewControllers()
 
 ⚠️ نصائح مهمة:
 ==============
 
 ✅ استخدم في التطبيق الحقيقي:
 - ضع safeSetupInitialViewController() في scene(_:willConnectTo:options:)
 - جميع واجهات Storyboard يجب أن تكون موجودة وصحيحة
 
 ✅ للتحكم في الانتقالات:
 - جميع الانتقالات تتم مع تأثير انتقال سلس
 - يتم حفظ حالة المستخدم تلقائياً
 - معالجة تلقائية للأخطاء
 
 ✅ للتشخيص والاختبار:
 - استخدم debugSystemState() لمعرفة حالة النظام
 - استخدم testAllViewControllers() للتأكد من Storyboards
 
 */
