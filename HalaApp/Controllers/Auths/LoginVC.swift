//
//  LoginVC.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet  var mainView: [UIView]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberLabel: UILabel!
    @IBOutlet weak var rememberImageView: UIImageView!
    @IBOutlet weak var selectImageView: UIImageView!
    
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var IDontHaveAccountLable: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet var socialMediaView: [UIView]!
    @IBOutlet weak var socialMediaGoorleImageView: UIImageView!
    @IBOutlet weak var socialMediaAppleImageView: UIImageView!
    
    @IBOutlet weak var iHaveReadAndAgreeLabel: UILabel!
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    
    @IBOutlet weak var rememberButton: UIButton!
    @IBOutlet weak var loginWithGoogleButton: UIButton!
    @IBOutlet weak var loginWithAppleButton: UIButton!
    
    
    // MARK: - Properties
    var isRememberSelected: Bool = false {
        didSet {
            updateRememberSelection()
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupThemeObserver()
        print("✅ عرض واجهة تسجيل الدخول")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // تطبيق التدرج بعد تحديد أبعاد الزر
        updateButtonVisualState()
    }

    
    deinit {
        removeThemeObserver()
    }
    
    
}


extension LoginVC {
    
    private func setupUI() {
        // تطبيق السمات
        ThemeManager.shared.applyStoredTheme()
        
        setupViews()
        setupLables()
        setupTextFields()
        setupButton()
        setupImageViews()
    }
    
    private func setupViews() {
        // إعداد العروض الرئيسية
        mainView.forEach { views in
            views.backgroundColor = AppColors.secondBackground.color
            views.addCornerRadius(12)
            
        }
        
        // إعداد عروض وسائل التواصل الاجتماعي
        
        socialMediaView.forEach { views in
            views.backgroundColor = AppColors.background.color
            views.addCornerRadius(15)
            views.addBoarder(color: .boarderColor, width: 2)
        }
    }
    
    private func setupLables() {
        titleLabel.setupCustomLable(
            text: Lables.welcome.textName,
            textColor: .text,
            ofSize: .size_18,
            font: .cairo ,
            fontStyle: .bold ,)
        
        subtitleLabel.setupCustomLable(
            text: Lables.welcomeSubtitle.textName,
            textColor: .text,
            ofSize: .size_12,
            font: .cairo)
        
        rememberLabel.setupCustomLable(
            text: Lables.rememberMe.textName,
            textColor: .text,
            ofSize: .size_12,
            font: .cairo)
        
        iHaveReadAndAgreeLabel.setupCustomLable(
            text: Lables.iHaveReadAndAgree.textName,
            textColor: .text,
            ofSize: .size_12,
            font: .cairo)
        
        IDontHaveAccountLable.setupCustomLable(
            text: Lables.dontHaveAccount.textName,
            textColor: .text,
            ofSize: .size_12,
            font: .cairo)
        
        orLabel.setupCustomLable(
            text: Lables.orContinueWith.textName,
            textColor: .text, ofSize: .size_14,
            font: .cairo ,
            fontStyle: .bold ,
            alignment: .center)
    }
    
    private func setupTextFields() {
        emailTextField.setupCustomTextField(placeholder: .email)
        passwordTextField.setupAsPasswordField()

        // إضافة هدف للتحقق من صحة البيانات أثناء الكتابة
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupImageViews() {
        selectImageView.isHidden = true
        selectImageView.tintColor = AppColors.primary.color
    }
    
    private func setupButton() {
        loginButton.setupCustomButton(
            title: .login,
            titleColor: .buttonText,
            backgroundColor: .primary,
            ofSize: .size_18,
            font: .cairo ,
            fontStyle: .extraBold
        )
        
        loginButton.applyGradientBackground(
            colors: [.s_00C8FE , .e_4FACFE], direction: .leftToRight
        )
        
        loginButton.addCornerRadius(15)
        
        forgetPasswordButton.setupCustomButton(
            title: .forgotPassword,
            titleColor: .primary,
            ofSize: .size_12,
            font: .cairo
        )
        
        signupButton.setupCustomButton(
            title: .signup,
            titleColor: .primary,
            ofSize: .size_12, font: .cairo)
        termsAndConditionsButton.setupCustomButton(
            title: .terms,
            titleColor: .primary,
            ofSize: .size_12,
            font: .cairo
        )
       
        
        // إضافة الأهداف
        addButtonTargets()
        
        // تفعيل الزر بشكل افتراضي (حتى بدون بيانات)

        setupInteractiveLoginButton()
    }
    
 
    
    private func addButtonTargets() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        forgetPasswordButton.addTarget(self, action: #selector(forgetPasswordTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        rememberButton.addTarget(self, action: #selector(rememberTapped), for: .touchUpInside)
        termsAndConditionsButton.addTarget(self, action: #selector(termasTapped), for: .touchUpInside)
        loginWithGoogleButton.addTarget(self, action: #selector(loginWithGoogleTapped), for: .touchUpInside)
        loginWithAppleButton.addTarget(self, action: #selector(loginWithAppleTapped), for: .touchUpInside)

    }
    
    /// إعداد زر تسجيل الدخول ليكون تفاعلياً دائماً
    private func setupInteractiveLoginButton() {
        // الزر مفعل دائماً
        loginButton.isEnabled = true
        loginButton.alpha = 1.0
        
        // إضافة تأثيرات التفاعل
        loginButton.addTarget(self, action: #selector(loginButtonTouchDown), for: .touchDown)
        loginButton.addTarget(self, action: #selector(loginButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // تحديث مظهر الزر
        updateButtonVisualState()
    }

    private func updateButtonVisualState() {
        
        DispatchQueue.main.async {
            // تطبيق التدرج في الخيط الرئيسي بعد تحديد Layout
            self.loginButton.applyGradientBackground(
                colors: [.s_00C8FE, .e_4FACFE],
                direction: .leftToRight
            )

            // إضافة ظل خفيف
                     self.loginButton.layer.shadowColor = UIColor.systemBlue.cgColor
                     self.loginButton.layer.shadowOffset = CGSize(width: 0, height: 4)
                     self.loginButton.layer.shadowRadius = 8
                     self.loginButton.layer.shadowOpacity = 0.2
        }
    }
    
}

// MARK: - Action

extension LoginVC {
    
    @objc private func loginButtonTouchDown() {
        // تأثير الضغط
        UIView.animate(withDuration: 0.1) {
            self.loginButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.loginButton.alpha = 0.8
        }
    }
    
    @objc private func loginButtonTouchUp() {
        // إعادة الحجم الطبيعي
        UIView.animate(withDuration: 0.1) {
            self.loginButton.transform = .identity
            self.loginButton.alpha = 1.0
        }
    }

    
    @objc private func loginTapped() {
        
        print("🔐 تم الضغط على زر تسجيل الدخول")
        // التحقق من صحة البيانات أولاً
        if validateInputs() {
            showLoginAlert()
        }
        
        showLoginAlert()

        print("🔐 محاولة تسجيل دخول")
    }
    
    @objc private func forgetPasswordTapped() {
        // الانتقال لشاشة استعادة كلمة المرور
    //    goToVC(storyboard: .Auth, identifiers: .ForgotPassword)

        // مؤقتاً: عرض رسالة
        MessagesManager.shared.showInfo(
            title: "نسيت كلمة المرور",
            message: "سيتم إضافة هذه الميزة قريباً"
        )
        
        print("🔄 نسيت كلمة المرور")

    }
    
    @objc private func signupTapped() {

        // الانتقال لشاشة التسجيل
        // goToVC(storyboard: .Auth, identifiers: .Signup)
        
        // مؤقتاً: عرض رسالة
        MessagesManager.shared.showInfo(
            title: "إنشاء حساب جديد",
            message: "سيتم إضافة هذه الميزة قريباً"
        )
        
        print("📝 إنشاء حساب جديد")

    }
    
    @objc private func rememberTapped() {
        // تبديل حالة التذكر مع تأثير بصري
        HapticManager.shared.lightImpact() // تأثير اهتزاز خفيف
        isRememberSelected.toggle()
        print("💭 تذكرني: \(isRememberSelected ? "مفعل" : "غير مفعل")")

    }
        
    @objc private func termasTapped() {
        // عرض الشروط والأحكام
        showTermsAndConditions()
        print("📋 عرض الشروط والأحكام")

    }
    
    @objc private func loginWithGoogleTapped() {
        // تسجيل دخول بـ Google
        handleSocialLogin(provider: "Google")
        print("🔵 تسجيل دخول بـ Google")
    }

    @objc private func loginWithAppleTapped() {
        // تسجيل دخول بـ Apple
        handleSocialLogin(provider: "Apple")
        print("⚫ تسجيل دخول بـ Apple")
    }

    @objc private func textFieldDidChange() {

    }

    
    
}

// MARK: - Helper Methods
extension LoginVC {
    
    private func updateRememberSelection() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.selectImageView.isHidden = !self.isRememberSelected
            self.selectImageView.transform = self.isRememberSelected ?
                CGAffineTransform(scaleX: 1.1, y: 1.1) : .identity
        } completion: { _ in
            if self.isRememberSelected {
                UIView.animate(withDuration: 0.2) {
                    self.selectImageView.transform = .identity
                }
            }
        }
        
        // حفظ الحالة
        UserDefault.shared.setData(isRememberSelected, forKey: "remember_me")
    }
    
    private func validateInputs() -> Bool {
        // التحقق من البريد الإلكتروني
        guard let email = emailTextField.text, !email.isEmpty else {
            MessagesManager.shared.showFieldRequired(Alerts.email.texts)
            emailTextField.becomeFirstResponder()
            return false
        }
        
        let emailValidation = (emailTextField.text ?? "").emailValidationResult
        
        if emailValidation.isValid {
            MessagesManager.shared.showValidationError(Alerts.invalidMail.texts)
            emailTextField.becomeFirstResponder()
            return false
        }
        

        // التحقق من كلمة المرور
            let passwordValidation = (passwordTextField.text ?? "").passwordValidationResult
            
        if !passwordValidation.isValid {
            MessagesManager.shared.showValidationError(Alerts.invalidMail.texts)
            passwordTextField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
 
    private func updateButtonVisualFeedback() {
        
        
        let hasEmail = !(emailTextField.text?.isEmpty ?? true)
        let hasPassword = !(passwordTextField.text?.isEmpty ?? true)
        let hasData = hasEmail && hasPassword
        
        // تأثير بصري خفيف عند وجود البيانات
        UIView.animate(withDuration: 0.2) {
            if hasData {
                self.loginButton.layer.shadowColor = UIColor.systemBlue.cgColor
                self.loginButton.layer.shadowOffset = CGSize(width: 0, height: 4)
                self.loginButton.layer.shadowRadius = 8
                self.loginButton.layer.shadowOpacity = 0.3
            } else {
                self.loginButton.layer.shadowOpacity = 0.1
            }
        }

    }
    
    private func showLoginAlert() {
        let hasValidData = validateInputs()
        let title = hasValidData ? "تأكيد تسجيل الدخول" : "تجربة تسجيل الدخول"
        let message = hasValidData ?
            "هل تريد المتابعة لتسجيل الدخول؟" :
            "البيانات غير مكتملة، هل تريد تجربة تسجيل الدخول كمثال؟"
        
        MessagesManager.shared.showDialog(
            title: title,
            message: message,
            primaryButtonTitle: "متابعة",
            secondaryButtonTitle: "إلغاء",
            primaryAction: { [weak self] in
                self?.performLogin()
            }
        )
    }

    
    private func performLogin() {
        // إظهار مؤشر التحميل
        MessagesManager.shared.showLoading(titleType: .connecting, messageType: .pleaseWait)
        
        // محاكاة عملية تسجيل الدخول
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            MessagesManager.shared.hide()
            
            // محاكاة نجاح/فشل تسجيل الدخول
            let isSuccess = Bool.random()
            
            if isSuccess {
                self?.handleLoginSuccess()
            } else {
                self?.handleLoginFailure()
            }
        }
    }
    
    private func handleLoginSuccess() {
        // تأثير نجاح
        HapticManager.shared.successImpact()
        
        // إظهار رسالة نجاح
        MessagesManager.shared.showSuccess(titleType: .success, messageType: .success)
        
        // حفظ بيانات المستخدم (محاكاة)
        let token = "fake_token_\(UUID().uuidString)"
        let userId = "user_\(Int.random(in: 1000...9999))"
        let userName = emailTextField.text?.components(separatedBy: "@").first
        
        // الانتقال للتطبيق الرئيسي
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // AppNavigationManager.shared.loginSuccess(token: token, userId: userId, userName: userName)
            print("🎉 تم تسجيل الدخول بنجاح - Token: \(token)")
        }
    }

    
    private func handleLoginFailure() {
        // تأثير فشل
        HapticManager.shared.errorImpact()
        
        // إظهار رسالة خطأ
        MessagesManager.shared.showError(
            title: "فشل تسجيل الدخول",
            message: "البريد الإلكتروني أو كلمة المرور غير صحيحة"
        )
        
        // تنظيف كلمة المرور
        passwordTextField.text = ""
        passwordTextField.becomeFirstResponder()
        
        // تأثير اهتزاز للزر
        shakeLoginButton()
    }

    private func shakeLoginButton() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        loginButton.layer.add(animation, forKey: "shake")
    }

    
    private func handleSocialLogin(provider: String) {
        // إظهار مؤشر التحميل للتسجيل الاجتماعي
        MessagesManager.shared.showLoading(
            title: "تسجيل الدخول بـ \(provider)",
            message: "جاري الاتصال..."
        )
        
        // محاكاة عملية التسجيل الاجتماعي
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            MessagesManager.shared.hide()
            MessagesManager.shared.showInfo(
                title: "قريباً",
                message: "تسجيل الدخول بـ \(provider) متاح قريباً"
            )
        }
    }
    
    private func showTermsAndConditions() {
        MessagesManager.shared.showDialog(
            title: "الشروط والأحكام",
            message: "هل تريد قراءة الشروط والأحكام؟",
            primaryButtonTitle: "قراءة",
            secondaryButtonTitle: "إغلاق",
            primaryAction: {
                // الانتقال لشاشة الشروط والأحكام
                print("📖 فتح الشروط والأحكام")
            }
        )
    }
}


// MARK: - Theme Support
extension LoginVC {
    
    override func updateUIForCurrentTheme() {
        view.setBackgroundColor(.background)
        
        // تحديث ألوان العناصر حسب النمط
        titleLabel.textColor = AppColors.text.color
        subtitleLabel.textColor = AppColors.textSecondary.color
        
        // تحديث ألوان الحقول
        emailTextField.backgroundColor = AppColors.secondBackground.color
        passwordTextField.backgroundColor = AppColors.secondBackground.color
        
        // تحديث ألوان العروض
        mainView.forEach { view in
            view.backgroundColor = AppColors.secondBackground.color
        }
        
        socialMediaView.forEach { view in
            view.backgroundColor = AppColors.background.color
            view.layer.borderColor = AppColors.boarderColor.color.cgColor
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            DispatchQueue.main.async {
                self.updateUIForCurrentTheme()
            }
        }
    }
}


// MARK: - Haptic Manager (اختياري)
