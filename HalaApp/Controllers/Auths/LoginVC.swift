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
        makeResponsive()
        setupDismissKeyboardGesture()
        
        print("✅ عرض واجهة تسجيل الدخول")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // تطبيق التدرج بعد تحديد أبعاد الزر
        updateButtonVisualState()
    }
    
        //دالة تنظيف
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanup()
    }

    
    deinit {
        cleanup()
    }
    
}


extension LoginVC {
    
    private func setupUI() {
        // تطبيق السمات
        ThemeManager.shared.applyStoredTheme()
        
        setupViews()
        setupLables()
        setupTextFields()
        setupButtons()
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
            fontStyle: .bold ,
            responsive: true
        )
        
        subtitleLabel.setupCustomLable(
            text: Lables.welcomeSubtitle.textName,
            textColor: .text,
            ofSize: .size_12,
            font: .cairo,
            responsive: true
        )
        
        rememberLabel.setupCustomLable(
            text: Lables.rememberMe.textName,
            textColor: .text,
            ofSize: .size_12,
            font: .cairo,
            responsive: true
        )
        
     
        
        IDontHaveAccountLable.setupCustomLable(
            text: Lables.dontHaveAccount.textName,
            textColor: .text,
            ofSize: .size_12,
            font: .cairo,
            responsive: true
        )
        
        orLabel.setupCustomLable(
            text: Lables.orContinueWith.textName,
            textColor: .text, ofSize: .size_14,
            font: .cairo ,
            fontStyle: .bold ,
            alignment: .center,
            responsive: true
        )
    }
    
    
    private func setupTextFields() {

        emailTextField.setupCustomTextField(placeholder: .email , keyboardType: .emailAddress)
        passwordTextField.setupAsPasswordField()

        // إضافة هدف للتحقق من صحة البيانات أثناء الكتابة
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupImageViews() {
        selectImageView.isHidden = true
        selectImageView.tintColor = AppColors.primary.color
    }
    
    private func setupButtons() {
        loginButton.setupCustomButton(
            title: .login,
            titleColor: .buttonText,
            backgroundColor: .primary,
            ofSize: .size_18,
            font: .cairo ,
            fontStyle: .extraBold,
            responsive: true
        )
        
        loginButton.applyGradientBackground(
            colors: [.s_00C8FE , .e_4FACFE],
            direction: .leftToRight
        )
        
        loginButton.addCornerRadius(15)
        
        forgetPasswordButton.setupCustomButton(
            title: .forgotPassword,
            titleColor: .primary,
            ofSize: .size_12,
            font: .cairo,
            responsive: true
        )
        
        signupButton.setupCustomButton(
            title: .signup,
            titleColor: .primary,
            ofSize: .size_12, font: .cairo)
     
       
        
        // إضافة الأهداف
        addButtonTargets()

}
    
 
    private func addButtonTargets() {
        // استخدم فقط setupInteractiveButton - لا تضع addTarget عادي
        setupInteractiveButton(loginButton, tapAction: #selector(loginTapped), hapticFeedback: true)
        setupInteractiveButton(forgetPasswordButton, tapAction: #selector(forgetPasswordTapped), hapticFeedback: true)
        setupInteractiveButton(signupButton, tapAction: #selector(signupTapped), hapticFeedback: true)
        setupInteractiveButton(rememberButton, tapAction: #selector(rememberTapped), hapticFeedback: true)
        setupInteractiveButton(loginWithGoogleButton, tapAction: #selector(loginWithGoogleTapped), hapticFeedback: true)
        setupInteractiveButton(loginWithAppleButton, tapAction: #selector(loginWithAppleTapped), hapticFeedback: true)
    }


    private func updateButtonVisualState() {
        
        DispatchQueue.main.async {
            // تطبيق التدرج في الخيط الرئيسي بعد تحديد Layout
            self.loginButton.applyGradientBackground(
                colors: [.s_F78361, .e_F54B64],
                direction: .diagonal
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


    
    @objc private func loginTapped() {
        
        print("🔐 تم الضغط على زر تسجيل الدخول")
        // التحقق من صحة البيانات أولاً
        
        // تأثير بصري للزر
        loginButton.rippleAnimation()
        
        showLoginAlert()

        print("🔐 محاولة تسجيل دخول")
    }
    
    @objc private func forgetPasswordTapped() {
        print("🔄 نسيت كلمة المرور")

        // أنيميشن انتقال سلس
        forgetPasswordButton.scaleAnimation(from: 1.0, to: 0.95) {
            // الانتقال لشاشة استعادة كلمة المرور
            self.goToVC(storyboard: .Auth, identifiers: .ForgotPassword)
        }
  
    }
    
    @objc private func signupTapped() {
        
        print("📝 إنشاء حساب جديد")

        signupButton.bounceAnimation {
            // الانتقال لشاشة التسجيل
            self.goToVC(storyboard: .Auth, identifiers: .SignUp)

        }
    }
    
    @objc private func rememberTapped() {
        print("💭 تذكرني: \(isRememberSelected ? "مفعل" : "غير مفعل")")
        
        // أنيميشن تبديل الحالة
        rememberButton.buttonTapAnimation {
            self.isRememberSelected.toggle()
        }

    }
        
    
    @objc private func loginWithGoogleTapped() {
        // تسجيل دخول بـ Google
        print("🔵 تسجيل دخول بـ Google")
        loginWithGoogleButton.pulseAnimation()
        handleSocialLogin(provider: "Google")

    }

    @objc private func loginWithAppleTapped() {
        print("⚫ تسجيل دخول بـ Apple")
        // تأثير اهتزاز عند الضغط
        loginWithAppleButton.pulseAnimation()
        handleSocialLogin(provider: "Apple")
    }

    @objc private func textFieldDidChange() {

        // تحديث المظهر البصري للزر عند تغيير النص
        updateButtonVisualFeedback()
    }
    
}


// MARK: - Helper Methods
extension LoginVC {
    
    private func updateRememberSelection() {
        let config = AnimationConfig(duration: 0.25) {
            self.selectImageView.isHidden = !self.isRememberSelected
            
            if self.isRememberSelected {
                self.selectImageView.animate(.scale(from: 1.1, to: 1.0))
            }
        }
        
        if isRememberSelected {
            selectImageView.animate(.scale(from: 0.8, to: 1.1), config: config)
        } else {
            selectImageView.animate(.fadeOut, config: config)
        }
        
        UserDefaultsManager.rememberMe = isRememberSelected
    }
    
    private func validateInputs() -> Bool {
        clearAllValidationErrors(mainView)
        
        let emailValidation = (
            view: mainView.first { $0.tag == 0 } ?? mainView[0],
            isValid: emailTextField.text?.emailValidationResult.isValid ?? false
        )
        
        let passwordValidation = (
            view: mainView.first { $0.tag == 1 } ?? mainView[1],
            isValid: !(passwordTextField.text?.isEmpty ?? true)
        )
        
        let validations = [emailValidation, passwordValidation]
        let isValid = validateFields(validations, showSuccess: false)
        
        if !isValid {
            HapticManager.shared.errorImpact()
        }
        
        return isValid
    }
    
    
    private func updateButtonVisualFeedback() {
        let hasEmail = !(emailTextField.text?.isEmpty ?? true)
        let hasPassword = !(passwordTextField.text?.isEmpty ?? true)
        let hasData = hasEmail && hasPassword
        
        UIView.animate(withDuration: 0.2) {
            self.loginButton.layer.shadowOpacity = hasData ? 0.3 : 0.1
        }
    }
    
    private func showLoginAlert() {
        let hasValidData = validateInputs()
        
        let title: String
        let message: String
        let primaryButtonTitle: String
        
        if hasValidData {
            title = "تسجيل الدخول"
            message = "هل أنت متأكد من تسجيل الدخول بالبيانات التالية؟"
            primaryButtonTitle = "تسجيل الدخول"
        } else {
            title = "تجربة النظام"
            message = "البيانات غير مكتملة، هل تريد تجربة النظام كمثال؟"
            primaryButtonTitle = "تجربة"
        }
        
        NativeMessagesManager.shared.showDialog(
            title: title,
            message: message,
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonTitle: Alerts.cancel.texts,
            primaryAction: { [weak self] in
                self?.performLogin(withValidData: hasValidData)
            },
            secondaryAction: { [weak self] in
                print("❌ تم إلغاء تسجيل الدخول")
                HapticManager.shared.lightImpact()
            }
        )
    }
    
    private func performLogin(withValidData: Bool = true) {
        showLoadingState(
            button: loginButton,
            originalTitle: "تسجيل الدخول",
            loadingTitle: "جاري التحميل..."
        )
        
        NativeMessagesManager.shared.showLoading(
            titleType: .connecting,
            messageType: .pleaseWait
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            
            NativeMessagesManager.shared.hide()
            self.hideLoadingState(button: self.loginButton)
            
            let email = self.emailTextField.text ?? "demo@app.com"
            let userName = email.components(separatedBy: "@").first ?? "مستخدم تجريبي"
            
            self.showSuccessAnimation(view: self.loginButton, message: "تم تسجيل الدخول بنجاح") {
                AppNavigationManager.shared.loginSuccess(
                    token: "temp_token_123",
                    userId: "user_\(Int.random(in: 1000...9999))",
                    userName: userName
                )
            }
        }
    }
    
    private func handleSocialLogin(provider: String) {
        NativeMessagesManager.shared.handleSocialLogin(provider: provider)
    }
    
    private func cleanup() {
        removeThemeObserver()
        NativeMessagesManager.shared.hideAll()
        view.subviews.forEach { $0.layer.removeAllAnimations() }
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
        

