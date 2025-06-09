import UIKit



final class AppNavigationManager {
    
    // MARK: - Singleton
    static let shared = AppNavigationManager()
    private init() {}
    
    // MARK: - Main Setup Method
    /// إعداد الواجهة الأولى المناسبة
    func setupInitialViewController() {
        
        guard let window = getWindow() else {
            print("❌ لا يمكن الوصول للنافذة")
            return
        }
        
        print("🔍 تحديد الواجهة المناسبة...")
        
        // تحديد الواجهة حسب حالة المستخدم
        let viewController = determineViewController()
        
        // عرض الواجهة
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        print("✅ تم عرض الواجهة: \(String(describing: type(of: viewController)))")
    }
    
    // MARK: - Private Methods
    
    /// تحديد الواجهة المناسبة
    private func determineViewController() -> UIViewController {
        
        let hasCompletedOnboarding = UserDefault.shared.hasCompletedOnboarding
        let isLoggedIn = UserDefault.shared.isLoggedIn
        
        print("📊 حالة التطبيق:")
        print("   - مكمل التعريف: \(hasCompletedOnboarding ? "✅" : "❌")")
        print("   - مسجل دخول: \(isLoggedIn ? "✅" : "❌")")
        
        // ⚠️ إصلاح المنطق:
        
        // 1️⃣ لم يكمل التعريف → عرض التعريف
        if !hasCompletedOnboarding {
            print("🎯 عرض واجهة التعريف")
            return loadOnboardingViewController()
        }
        
        // 2️⃣ لم يسجل دخول → عرض تسجيل الدخول
        if !isLoggedIn {
            print("🔐 عرض واجهة تسجيل الدخول")
            return loadLoginViewController()
        }
        
        // 3️⃣ كل شيء تم → عرض التطبيق الرئيسي
        print("🏠 عرض التطبيق الرئيسي")
        return loadMainViewController()
    }
    
    /// تحميل واجهة التعريف
    private func loadOnboardingViewController() -> UIViewController {
        // محاولة تحميل من Storyboard
        if let onboardingVC = Storyboards.Onboarding.instantiateViewController(withIdentifier: .Onboarding) {
            print("✅ تم تحميل OnboardingVC من Storyboard")
            return UINavigationController(rootViewController: onboardingVC)
        }
        
        print("⚠️ فشل تحميل OnboardingVC - عرض واجهة بديلة")
        return createFallbackOnboardingViewController()
    }
    
    /// تحميل واجهة تسجيل الدخول
    private func loadLoginViewController() -> UIViewController {
        // محاولة تحميل من Storyboard
        if let loginVC = Storyboards.Auth.instantiateViewController(withIdentifier: .Login) {
            print("✅ تم تحميل LoginVC من Storyboard")
            return UINavigationController(rootViewController: loginVC)
        }
        
        print("⚠️ فشل تحميل LoginVC - عرض واجهة بديلة")
        return createFallbackLoginViewController()
    }
    
    /// تحميل الواجهة الرئيسية
    private func loadMainViewController() -> UIViewController {
        // محاولة تحميل من Storyboard
        if let mainVC = Storyboards.Main.instantiateViewController(withIdentifier: .Main) {
            print("✅ تم تحميل MainVC من Storyboard")
            return UINavigationController(rootViewController: mainVC)
        }
        
        print("⚠️ فشل تحميل MainVC - عرض واجهة بديلة")
        return createFallbackMainViewController()
    }
    
    /// الحصول على النافذة
    private func getWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows.first
        } else {
            return UIApplication.shared.windows.first
        }
    }
    
    // MARK: - Public Navigation Methods
    
    /// إكمال التعريف والانتقال للمرحلة التالية
    func completeOnboarding() {
        UserDefault.shared.hasCompletedOnboarding = true
        
        if UserDefault.shared.isLoggedIn {
            navigateToMain()
        } else {
            navigateToLogin()
        }
        
        print("✅ تم إكمال التعريف")
    }
    
    /// تسجيل دخول ناجح
    func loginSuccess(token: String, userId: String, userName: String? = nil) {
        UserDefault.shared.userToken = token
        UserDefault.shared.userId = userId
        UserDefault.shared.userName = userName
        
        navigateToMain()
        
        print("🎉 تم تسجيل الدخول بنجاح")
    }
    
    /// تسجيل خروج
    func logout() {
        UserDefault.shared.logoutUser()
        navigateToLogin()
        
        print("🚪 تم تسجيل الخروج")
    }
    
    /// الانتقال للتطبيق الرئيسي
    private func navigateToMain() {
        guard let window = getWindow() else { return }
        
        let mainVC = loadMainViewController()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = mainVC
        }
        
        print("🏠 تم الانتقال للتطبيق الرئيسي")
    }
    
    /// الانتقال لتسجيل الدخول
    private func navigateToLogin() {
        guard let window = getWindow() else { return }
        
        let loginVC = loadLoginViewController()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = loginVC
        }
        
        print("🔐 تم الانتقال لتسجيل الدخول")
    }
}





// MARK: - Fallback ViewControllers (للاختبار فقط)
extension AppNavigationManager {
    
    /// واجهة التعريف البديلة
    private func createFallbackOnboardingViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.setBackgroundColor(.background)
        
        let titleLabel = UILabel()
        titleLabel.setupCustomLable(
            text: "مرحباً بك في التطبيق",
            textColor: .text,
            ofSize: .size_24,
            font: .cairo,
            fontStyle: .bold,
            alignment: .center
        )
        
        let continueButton = UIButton()
        continueButton.setupCustomButton(
            title: .Continuation,
            titleColor: .buttonText,
            backgroundColor: .primary,
            ofSize: .size_16,
            font: .cairo,
            fontStyle: .semiBold
        )
        continueButton.addCornerRadius(12)
        continueButton.addTarget(self, action: #selector(fallbackOnboardingContinue), for: .touchUpInside)
        
        setupFallbackView(vc: vc, title: titleLabel, button: continueButton)
        
        return UINavigationController(rootViewController: vc)
    }
    
    /// واجهة تسجيل الدخول البديلة
    private func createFallbackLoginViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.setBackgroundColor(.background)
        
        let titleLabel = UILabel()
        titleLabel.setupCustomLable(
            text: "تسجيل الدخول",
            textColor: .text,
            ofSize: .size_24,
            font: .cairo,
            fontStyle: .bold,
            alignment: .center
        )
        
        let loginButton = UIButton()
        loginButton.setupCustomButton(
            title: .Continuation,
            titleColor: .buttonText,
            backgroundColor: .primary,
            ofSize: .size_16,
            font: .cairo,
            fontStyle: .semiBold
        )
        loginButton.addCornerRadius(12)
        loginButton.addTarget(self, action: #selector(fallbackLoginPressed), for: .touchUpInside)
        
        setupFallbackView(vc: vc, title: titleLabel, button: loginButton)
        
        return UINavigationController(rootViewController: vc)
    }
    
    /// الواجهة الرئيسية البديلة
    private func createFallbackMainViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.setBackgroundColor(.background)
        
        let titleLabel = UILabel()
        titleLabel.setupCustomLable(
            text: "التطبيق الرئيسي",
            textColor: .text,
            ofSize: .size_24,
            font: .cairo,
            fontStyle: .bold,
            alignment: .center
        )
        
        let logoutButton = UIButton()
        logoutButton.setupCustomButton(
            title: .SignOut,
            titleColor: .buttonText,
            backgroundColor: .error,
            ofSize: .size_16,
            font: .cairo,
            fontStyle: .semiBold
        )
        
        logoutButton.addCornerRadius(12)
        logoutButton.addTarget(self, action: #selector(fallbackLogoutPressed), for: .touchUpInside)
        
        setupFallbackView(vc: vc, title: titleLabel, button: logoutButton)
        
        return UINavigationController(rootViewController: vc)
    }
    
    /// إعداد الواجهة البديلة
    private func setupFallbackView(vc: UIViewController, title: UILabel, button: UIButton) {
        [title, button].forEach {
            vc.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor, constant: -50),
            
            button.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 32),
            button.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 32),
            button.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -32),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Fallback Actions
    
    @objc private func fallbackOnboardingContinue() {
        print("🎯 تم الضغط على متابعة")
        completeOnboarding()
    }
    
    @objc private func fallbackLoginPressed() {
        print("🔐 تم الضغط على تسجيل دخول")
        loginSuccess(token: "temp_token_123", userId: "temp_user_456", userName: "مستخدم تجريبي")
    }
    
    @objc private func fallbackLogoutPressed() {
        print("🚪 تم الضغط على تسجيل خروج")
        logout()
    }
}

