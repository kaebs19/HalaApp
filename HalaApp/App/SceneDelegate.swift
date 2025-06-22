//
//  SceneDelegate.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 06/06/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // تهيئة النافذة وربطها بالمشهد
        guard let windowScene = (scene as? UIWindowScene) else {
            print("❌ فشل في الحصول على WindowScene")
            return
        }
        
        // إعداد جميع أنظمة التطبيق عند البدء
        setupAppSystems()
        
        // إنشاء النافذة
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = AppColors.background.color
        window?.tintColor = AppColors.primary.color
        
        // إعداد الثيم
        ThemeManager.shared.applyStoredTheme()
        ThemeManager.shared.startSystemThemeObserver()
        
        setupThemeSystem()
        
        // تحديد وعرض الواجهة المناسبة
        setupInitialViewController()
        
        // عرض النافذة
        window?.makeKeyAndVisible()
        
        print("🚀 تم إطلاق التطبيق بنجاح")

    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        

    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        // التحقق من الثيم عند عودة التطبيق للنشاط
        if ThemeManager.shared.currentTheme == .auto {
            ThemeManager.shared.applyTheme(.auto , animated: false)
        }
        
        print("✅ التطبيق أصبح نشطاً")

        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        // تحديث الواجهة عند العودة للمقدمة
        
        print("🔄 التطبيق عاد للمقدمة")

    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // حفظ الحالة عند دخول الخلفية
        handleAppDidEnterBackground()
        
        print("🌙 التطبيق دخل للخلفية")

    }
    
    
    
}


extension SceneDelegate {
    
    // MARK: - App Setup Methods
    
    /// إعداد جميع أنظمة التطبيق عند البدء
    private func setupAppSystems() {
        // 1️⃣ إعداد نظام الثيمز أولاً
        setupThemeSystem()
        
        // 2️⃣ إعداد نظام التنقل
        setupNavigationSystem()
        
        // 3️⃣ إعدادات إضافية
        setupAdditionalSystems()
        
      //  print("✅ تم إعداد جميع أنظمة التطبيق")
        
    }
    
    /// إعداد نظام الثيمز
    private func setupThemeSystem() {
        // تطبيق الثيم المحفوظ فوراً
        ThemeManager.shared.applyStoredTheme()

        // بدء مراقبة تغييرات ثيم النظام
        ThemeManager.shared.startSystemThemeObserver()
            
        
    }
    
    /// إعداد نظام التنقل
    private func setupNavigationSystem() {
        
        // تحديد وإعداد الواجهة الأولى المناسبة
        AppNavigationManager.shared.setupInitialViewController()
      //  print("🚀 تم إعداد نظام التنقل")
    }
    
    /// إعدادات إضافية أخرى
    func setupAdditionalSystems() {
        
        setupFonts()
        
        // إعداد مراقبة حالة الشبكة
        setupNetworkMonitoring()
        
        // إعداد التحليلات
        setupAnalytics()
        
        // إعداد الإشعارات
        setupNotifications()
        
    //    print("⚙️ تم إعداد الأنظمة الإضافية")
    }
    
    /// إعداد الخطوط المخصصة
    private func setupFonts() {
        // تحميل الخطوط المخصصة إن وجدت
//        FontManager.shared()
      //  print("🔤 تم إعداد الخطوط")
    }
    
    /// إعداد مراقبة حالة الشبكة
    private func setupNetworkMonitoring() {
        // يمكن إضافة Reachability هنا
      //  print("🌐 تم إعداد مراقبة الشبكة")
    }

    
    /// إعداد التحليلات
    private func setupAnalytics() {
        // إعداد Firebase Analytics أو أي خدمة تحليلات أخرى
   //     print("📊 تم إعداد التحليلات")
    }

    /// إعداد الإشعارات
    private func setupNotifications() {
        // طلب إذن الإشعارات إذا لزم الأمر
     //   print("🔔 تم إعداد الإشعارات")
    }

}


// MARK: - Setup Methods
extension SceneDelegate {
    
    /// تحديد وعرض الواجهة المناسبة
    private func setupInitialViewController() {
        
        let hasCompletedOnboarding = UserDefaultsManager.hasCompletedOnboarding
        let isLoggedIn = UserDefaultsManager.isLoggedIn
        
        print("📊 حالة التطبيق:")
        print("   - مكمل التعريف: \(hasCompletedOnboarding ? "✅" : "❌")")
        print("   - مسجل دخول: \(isLoggedIn ? "✅" : "❌")")
        
        // تحديد الواجهة المناسبة
        let initialViewController: UIViewController?
        
        if !hasCompletedOnboarding {
            print("🎯 عرض واجهة التعريف")
            initialViewController = loadOnboardingViewController()
        } else if !isLoggedIn {
            print("🔐 عرض واجهة تسجيل الدخول")
            initialViewController = loadLoginViewController()
        } else {
            print("🏠 عرض التطبيق الرئيسي")
            initialViewController = loadMainViewController()
        }
        
        // تعيين الواجهة
        if let viewController = initialViewController {
            window?.rootViewController = viewController
            print("✅ تم تعيين الواجهة بنجاح")
        } else {
            print("❌ فشل في تحميل الواجهة")
        }
    }
    
    /// تحميل واجهة التعريف
    private func loadOnboardingViewController() -> UIViewController? {
        guard let onboardingVC = Storyboards.Onboarding.instantiateViewController(withIdentifier: .Onboarding) else {
            print("❌ فشل في تحميل OnboardingVC من Storyboard")
            return nil
        }
        
        print("✅ تم تحميل OnboardingVC من Storyboard")
        return UINavigationController(rootViewController: onboardingVC)
    }
    
    /// تحميل واجهة تسجيل الدخول
    private func loadLoginViewController() -> UIViewController? {
        guard let loginVC = Storyboards.Auth.instantiateViewController(withIdentifier: .Login) else {
            print("❌ فشل في تحميل LoginVC من Storyboard")
            return nil
        }
        
        print("✅ تم تحميل LoginVC من Storyboard")
        return UINavigationController(rootViewController: loginVC)
    }
    
    /// تحميل الواجهة الرئيسية
    private func loadMainViewController() -> UIViewController? {
        guard let mainVC = Storyboards.Main.instantiateViewController(withIdentifier: .Main) else {
            print("❌ فشل في تحميل MainVC من Storyboard")
            return nil
        }
        
        print("✅ تم تحميل MainVC من Storyboard")
        return UINavigationController(rootViewController: mainVC)
    }
}


extension SceneDelegate {
    
    // MARK: - App State Handling
    
    /// تنظيف الذاكرة
    private func cleanupMemory() {
        URLCache.shared.removeAllCachedResponses()
        print("🧹 تم تنظيف الذاكرة")
    }


    /// معالجة دخول التطبيق للخلفية
    private func handleAppDidEnterBackground() {
        // حفظ حالة التطبيق
       // saveAppState()
        
        // تنظيف الذاكرة
       // cleanupMemory()
        
        // جدولة الإشعارات المحلية إذا لزم الأمر
        // scheduleLocalNotifications()
    }
    
    /// تحديث الواجهة
//    private func refreshUI() {
//        DispatchQueue.main.async {
//            // تحديث الواجهة إذا لزم الأمر
//            if let topVC = AppNavigationManager.shared.getTopViewController() {
//                // إشعار الـ ViewController بتحديث الواجهة
//                NotificationCenter.default.post(name: .appDidBecomeActive, object: nil)
//            }
//        }
//
//        print("🎨 تم تحديث الواجهة")
//    }

 
}
