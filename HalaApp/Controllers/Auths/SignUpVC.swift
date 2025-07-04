//
//  SignUpVC.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 20/06/2025.
//

import UIKit

class SignUpVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet  var mainView: [UIView]!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var iAgreeLabel: UILabel!
    @IBOutlet weak var iHaveReadAndAgreeLabel: UILabel!
    @IBOutlet weak var termsAndConditionsButton: UIButton!

    
    // MARK: - Properties

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        makeResponsive()

        // اخفاء لوحة المفاتح
        setupDismissKeyboardGesture()

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


extension SignUpVC {
    
    private func setupUI() {
        // تطبيق السمات
        ThemeManager.shared.applyStoredTheme()
        setNavigationButtons(items: [.backText] , title: .signup )
        
        
        setupViews()
        setupImages()
        setupButtons()
        setupLables()
        setupTextFields()
    }
    
    private func setupViews() {
        mainView.forEach { view in
            view.backgroundColor = AppColors.secondBackground.color
            view.addCornerRadius(15)
        }
    }
    
    private func setupImages() {
        logoImageView.image = ImageManager.logoImage

    }
    
    private func setupLables() {
        
        // إعداد التسميات
        createAccountLabel.setupCustomLable(text: Lables.createAccount.textName,
                                            textColor: .text,
                                            ofSize: .size_18,
                                            font: .cairo ,fontStyle: .semiBold,
                                            responsive: true
        )
        iAgreeLabel.setupCustomLable(text: Lables.iAgree.textName,
                                     textColor: .textSecondary,
                                     ofSize: .size_12,
                                     font: .cairo,
                                     responsive: true
        )
        
        iHaveReadAndAgreeLabel.setupCustomLable(
            text: Lables.iHaveReadAndAgree.textName,
            textColor: .text,
            ofSize: .size_12,
            font: .cairo,
            responsive: true
        )
    }

    
    private func setupTextFields() {
        userNameTextField.setupCustomTextField(
            placeholder: .username,
            textColor: .text,
            placeholderColor: .placeholder,
            returnKeyType: .next
        )
        
        emailTextField.setupCustomTextField(
            placeholder: .email,
            textColor: .placeholder,
            keyboardType: .emailAddress,
            returnKeyType: .next
        )

        
        passwordTextField.setupCustomTextField(
            placeholder: .password,
            textColor: .placeholder,
            returnKeyType: .next
        )

        confirmPasswordTextField.setupCustomTextField(
            placeholder: .confirmPassword,
            textColor: .placeholder,
            returnKeyType: .next
        )

      

        // إضافة أهداف للتحقق من صحة البيانات
        addTextFieldTargets()

        setupBirthYearField()
    }
    
    private func setupBirthYearField() {
        
        dateOfBirthTextField.setupAsYearField(
            placeholder: .dateOfBirth,
            textColor: .text,
            placeholderColor: .placeholder
            )
   
        dateOfBirthTextField.addTarget(
            self,
            action: #selector(yearFieldDidChange),
            for: .editingChanged
        )
    
        print("✅ تم إعداد حقل سنة الميلاد")


    }
    
   private func setupButtons() {
       signupButton.setupCustomButton(title: .signup,
                                      titleColor: .buttonText,
                                      ofSize: .size_18,
                                      font: .cairo,
                                      fontStyle: .extraBold,
                                    responsive: true
       )
       signupButton.addCornerRadius(15)
       
       
       termsAndConditionsButton.setupCustomButton(
           title: .terms,
           titleColor: .primary,
           ofSize: .size_12,
           font: .cairo,
           responsive: true
       )
       
       addButtonTargets()
       
    }
    
    private func addTextFieldTargets() {
        // إضافة أهداف لحقول النص
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        dateOfBirthTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    private func addButtonTargets() {
        // إضافة أهداف للأزرار
        setupInteractiveButton(signupButton, tapAction: #selector(signupTapped), hapticFeedback: true)
        setupInteractiveButton(termsAndConditionsButton, tapAction: #selector(termasTapped), hapticFeedback: true)

    }


    
    private func updateButtonVisualState() {
        
        DispatchQueue.main.async {
            self.signupButton.applyGradientBackground(colors: [.s_F78361, .e_F54B64], direction: .diagonal)
        }
    }
    
    
    private func showTermsAndConditions() {
      
        NativeMessagesManager.shared.showDialog(
            title: "الشروط والأحكام",
            message: "هل تريد قراءة الشروط والأحكام الخاصة بالتطبيق؟",
            primaryButtonTitle: "قراءة",
            secondaryButtonTitle: "إغلاق",
            primaryAction: {
                print("📖 فتح الشروط والأحكام")
                HapticManager.shared.successImpact()
            },
            secondaryAction: {
                print("❌ إغلاق حوار الشروط والأحكام")
                HapticManager.shared.lightImpact()
            }
        )
    }

}


// MARK: - Actions
extension SignUpVC {
    

    
    
    @objc private func signupTapped() {
        print("📝 تم الضغط على زر إنشاء حساب")
        
        // ✅ إضافة تأثير بصري
        signupButton.rippleAnimation()
        
        showSignupValidation()
    }
    
    @objc private func termasTapped() {
        // عرض الشروط والأحكام
        termsAndConditionsButton.pulseAnimation()
        
        // ✅ إضافة أنيميشن
        showTermsAndConditions()
        print("📋 عرض الشروط والأحكام")

    }

    @objc private func textFieldDidChange() {
        // يمكن إضافة منطق تحديث UI هنا لاحقاً

    }
    
    @objc private func yearFieldDidChange() {
        guard let text = dateOfBirthTextField.text else { return }
        
        // تحويل الأرقام العربية إلى إنجليزية
        let englishText = text.convertArabicToEnglishNumbers()
        
        // إذا تم التحويل، تحديث النص
        if englishText != text {
            dateOfBirthTextField.text = englishText
        }
        
        // التحقق من السنة
        validateBirthYear(englishText)
    }

}



// MARK: - 📝 validation

extension SignUpVC {
    
    private func showSignupValidation() {

        let validations = [
            (view: mainView[0], isValid: !(userNameTextField.text?.trimmed.isEmpty ?? true)),
            (view: mainView[1], isValid: emailTextField.text?.isValidEmail ?? false),
            (view: mainView[2], isValid: (passwordTextField.text?.count ?? 0) >= 6),
            (view: mainView[3], isValid: passwordTextField.text == confirmPasswordTextField.text),
            (view: mainView[4], isValid: isValidBirthYear(dateOfBirthTextField.text?.trimmed ?? ""))
        ]
        
        let isValid = validateFields(validations, showSuccess: false)
        
        if isValid {
            // ✅ إضافة أنيميشن نجاح
            showSuccessAnimation(view: signupButton, message: "تم التحقق بنجاح") {
                // منطق التسجيل
                self.performSignup()
            }
        }
        
    }
    
    private func performSignup() {
        showLoadingState(
            button: signupButton,
            originalTitle: "إنشاء حساب",
            loadingTitle: "جاري الإنشاء..."
        )
        
        NativeMessagesManager.shared.showLoading(
            title: "إنشاء الحساب",
            message: "يرجى الانتظار..."
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            
            NativeMessagesManager.shared.hide()
            self.hideLoadingState(button: self.signupButton)
            
            let userName = self.userNameTextField.text ?? "مستخدم جديد"
            
            self.showSuccessAnimation(view: self.signupButton, message: "تم إنشاء الحساب بنجاح") {
                // يمكن إضافة منطق التسجيل الناجح هنا
                self.navigationController?.popViewController(animated: true)
            }
        }

    }
    
    private func validateBirthYear(_ yearText: String) {
        // التحقق من أن النص يحتوي على أرقام فقط
        guard let year = Int(yearText), yearText.count == 4 else {
            return // لا نظهر خطأ أثناء الكتابة
        }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let age = currentYear - year
        
        // التحقق من العمر (أكبر من 16)
        if age >= 16 && age <= 80 {
            // عمر صالح - مؤشر بصري إيجابي
            showYearValidationFeedback(isValid: true, age: age)
        } else if age < 16 {
            // عمر صغير
            showYearValidationFeedback(isValid: false, message: "العمر يجب أن يكون 16 سنة على الأقل")
        } else {
            // عمر كبير
            showYearValidationFeedback(isValid: false, message: "يرجى التحقق من السنة المدخلة")
        }
    }
    
    private func showYearValidationFeedback(isValid: Bool, age: Int? = nil, message: String? = nil) {
        if isValid, let age = age {
            // تأثير نجاح
            HapticManager.shared.lightImpact()
            
            // يمكن إضافة مؤشر بصري هنا
            dateOfBirthTextField.layer.borderWidth = 1.0
            dateOfBirthTextField.layer.borderColor = UIColor.systemGreen.cgColor
            
            print("✅ العمر صالح: \(age) سنة")
        } else {
            // إزالة المؤشر الإيجابي
            dateOfBirthTextField.layer.borderWidth = 0
            
            if let message = message {
                print("⚠️ \(message)")
            }
        }
    }
    private func isValidBirthYear(_ yearText: String) -> Bool {
        // التحقق من وجود نص
        if yearText.isEmpty {
            return false
        }
        
        // التحقق من أن النص يحتوي على 4 أرقام
        guard yearText.count == 4, let year = Int(yearText) else {
            return false
        }
        
        // حساب العمر
        let currentYear = Calendar.current.component(.year, from: Date())
        let age = currentYear - year
        
        // التحقق من العمر
        if age < 16 {
            NativeMessagesManager.shared.showValidationError("العمر يجب أن يكون 16 سنة على الأقل")
            return false
        }
        
        if age > 80 {
            NativeMessagesManager.shared.showValidationError("يرجى التحقق من السنة المدخلة")
            return false
        }
        
        return true
    }

    
    /// رسالة خطأ بسيطة
    private func showValidationMessage(_ message: String) {
        NativeMessagesManager.shared.showErrorToast(message)
        HapticManager.shared.errorImpact()
    }
    
    /// رسالة نجاح مؤقتة
    private func showSuccessMessage() {
        HapticManager.shared.successImpact()
        NativeMessagesManager.shared.showSuccessToast("تم التحقق من البيانات بنجاح")
        
        print("✅ جميع البيانات صحيحة - جاهز للتسجيل")
        // هنا سيتم إضافة منطق التسجيل لاحقاً
    }

    private func cleanup() {
        removeThemeObserver()
        NativeMessagesManager.shared.hideAll()
        view.subviews.forEach { $0.layer.removeAllAnimations() }

    }
}


// MARK: - Theme Support
extension SignUpVC {
    
    override func updateUIForCurrentTheme() {
        
        view.setBackgroundColor(.background)
        // تحديث ألوان العناصر حسب النمط
        createAccountLabel.textColor = AppColors.text.color
        
        // تحديث ألوان العروض
        mainView.forEach { view in
            view.backgroundColor = AppColors.secondBackground.color
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
    

