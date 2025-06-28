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
        removeThemeObserver()
        // تنظيف الرسائل المعلقة - مهم جداً!

        NativeMessagesManager.shared.hideAll()
    }

    
    deinit {
        removeThemeObserver()
        
        // تنظيف الرسائل المعلقة - مهم جداً!
        NativeMessagesManager.shared.hideAll()
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
        setupLabels()
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
    
    private func setupLabels() {
        
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
       
       // إضافة الأهداف
       addButtonTargets()
       // إعداد الزر التفاعلي
       setupInteractiveSignupButton()
       
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
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        termsAndConditionsButton.addTarget(self, action: #selector(termasTapped), for: .touchUpInside)

    }

    
    private func setupInteractiveSignupButton() {
        // الزر مفعل دائماً
        signupButton.isEnabled = true
        signupButton.alpha = 1
        
        // إضافة تأثيرات التفاعل
        signupButton.addTarget(self, action: #selector(signupButtonTouchDown), for: .touchDown)
        signupButton.addTarget(self, action: #selector(signupButtonTouchUp), for: [.touchUpInside , .touchUpOutside , .touchCancel])
        
        // تحديث مظهر الزر
        updateButtonVisualState()

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
                // الانتقال لشاشة الشروط والأحكام
                // NavigationManager.shared.showTermsAndConditions()
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
    
    @objc private func signupButtonTouchDown() {
        HapticManager.shared.lightImpact()
        UIView.animate(withDuration: 0.1) {
            self.signupButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.signupButton.alpha = 0.8
        }

    }
    
    @objc private func signupButtonTouchUp() {
        // إعادة الحجم الطبيعي
        UIView.animate(withDuration: 0.1) {
            self.signupButton.transform = .identity
            self.signupButton.alpha = 1.0
        }
    }
    
    @objc private func signupTapped() {
        print("📝 تم الضغط على زر إنشاء حساب")
        
        // تأثير اهتزاز عند الضغط
        HapticManager.shared.mediumImpact()
        
        showSignupValidation()
    }
    
    @objc private func termasTapped() {
        // عرض الشروط والأحكام
        // تأثير اهتزاز عند الضغط
        HapticManager.shared.lightImpact()
        
        showTermsAndConditions()
        print("📋 عرض الشروط والأحكام")

    }

    @objc private func textFieldDidChange() {
       
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
        let userName = userNameTextField.text?.trimmed ?? ""
        let email = emailTextField.text?.trimmed ?? ""
        let password = passwordTextField.text?.trimmed ?? ""
        let confirmPassword = confirmPasswordTextField.text?.trimmed ?? ""
        

        let yearText = dateOfBirthTextField.text?.trimmed ?? ""


        // التحقق البسيط
        if userName.isEmpty {
            NativeMessagesManager.shared.showValidationError(Alerts.username.texts)
            return
        }
        
        if email.isEmpty {
            NativeMessagesManager.shared.showValidationError(Alerts.EmailIsEmpty.texts)

            return
        }
        
        if !email.isValidEmail {
            NativeMessagesManager.shared.showValidationError(Alerts.invalidMail.texts)
            return
        }
        
        if password.isEmpty {
            NativeMessagesManager.shared.showValidationError(Alerts.invalidPassword.texts)

            return
        }
        
        if password.count < 6 {
            NativeMessagesManager.shared.showValidationError(Alerts.PasswordIsShort.texts)

            return
        }
        
        if password != confirmPassword {
            NativeMessagesManager.shared.showValidationError(Alerts.PasswordDoesNotMatch.texts)

            return
        }
        
        if !isValidBirthYear(yearText) {

            return
        }
        
        // إذا نجح التحقق - عرض نجاح مؤقت
        NativeMessagesManager.shared.showSuccess(titleType: .success)

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
            NativeMessagesManager.shared.showValidationError("سنة الميلاد مطلوبة")
            return false
        }
        
        // التحقق من أن النص يحتوي على 4 أرقام
        guard yearText.count == 4, let year = Int(yearText) else {
            NativeMessagesManager.shared.showValidationError("يرجى إدخال سنة صحيحة (4 أرقام)")
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

}
