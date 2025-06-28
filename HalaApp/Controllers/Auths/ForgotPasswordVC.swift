//
//  ForgotPasswordVC.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 27/06/2025.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Properties
    private var isEmailValid = false {
        didSet {
            updateSendButtonState()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupThemeObserver()
        makeResponsive()
        setupDismissKeyboardGesture()
        
        print("✅ تم تحميل شاشة استعادة كلمة المرور")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateButtonVisualState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanup()
    }
    
    deinit {
        cleanup()
    }
}

// MARK: - Setup
extension ForgotPasswordVC {
    
    private func setupUI() {
        ThemeManager.shared.applyStoredTheme()
        
        setNavigationButtons(
            items: [.backText],
            title: .forgotPassword,
            isLargeTitle: true
        )
        
        setupLabels()
        setupImages()
        setupViews()
        setupTextField()
        setupButtons()
    }
    
    private func setupLabels() {
        detailsLabel.setupCustomLable(
            text: Lables.forgotPasswordSubtitle.textName,
            textColor: .text,
            ofSize: .size_16,
            font: .cairo,
            fontStyle: .regular,
            alignment: .center,
            numberOfLines: 0,
            responsive: true
        )
    }
    
    private func setupImages() {
        logoImageView.image = ImageManager.logoImage
    }
    
    private func setupViews() {
        mainView.backgroundColor = AppColors.secondBackground.color
        mainView.addCornerRadius(15)
        
        // ظل خفيف
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainView.layer.shadowOpacity = 0.1
        mainView.layer.shadowRadius = 4
    }
    
    private func setupTextField() {
        emailTextField.setupCustomTextField(
            placeholder: .email,
            textColor: .text,
            placeholderColor: .placeholder,
            keyboardType: .emailAddress,
            returnKeyType: .send
        )
        
        // ربط الأحداث
        emailTextField.delegate = self
        emailTextField.addTarget(
            self,
            action: #selector(emailTextFieldChanged),
            for: .editingChanged
        )
    }
    
    private func setupButtons() {
        sendButton.setupCustomButton(
            title: .send,
            titleColor: .buttonText,
            ofSize: .size_18,
            font: .cairo,
            fontStyle: .bold,
            alignment: .center,
            responsive: true
        )
        
        sendButton.addCornerRadius(15)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        // تأثيرات اللمس
        sendButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        sendButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        updateSendButtonState()
    }
    
    private func updateSendButtonState() {
        sendButton.isEnabled = isEmailValid
        sendButton.alpha = isEmailValid ? 1.0 : 0.6
        updateButtonVisualState()
    }
    
    private func updateButtonVisualState() {
        DispatchQueue.main.async {
            self.sendButton.applyGradientBackground(
                colors: [.s_F78361, .e_F54B64],
                direction: .diagonal
            )
            
            self.sendButton.layer.shadowColor = UIColor.systemRed.cgColor
            self.sendButton.layer.shadowOffset = CGSize(width: 0, height: 4)
            self.sendButton.layer.shadowRadius = 8
            self.sendButton.layer.shadowOpacity = self.sendButton.isEnabled ? 0.3 : 0.1
        }
    }
}

// MARK: - Actions
extension ForgotPasswordVC {
    
    @objc private func sendButtonTapped() {
        print("📧 تم الضغط على زر الإرسال")
        HapticManager.shared.mediumImpact()
        handlePasswordReset()
    }
    
    @objc private func emailTextFieldChanged() {
        guard let email = emailTextField.text?.trimmed else {
            isEmailValid = false
            return
        }
        
        let validationResult = email.emailValidationResult
        isEmailValid = validationResult.isValid
        updateEmailFieldAppearance(isValid: validationResult.isValid)
    }
    
    @objc private func buttonTouchDown() {
        HapticManager.shared.lightImpact()
        UIView.animate(withDuration: 0.1) {
            self.sendButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.sendButton.transform = .identity
        }
    }
}

// MARK: - Password Reset
extension ForgotPasswordVC {
    
    private func handlePasswordReset() {
        guard let email = emailTextField.text?.trimmed else { return }
        
        let validationResult = email.emailValidationResult
        
        if let errorMessage = validationResult.errorMessage {
            NativeMessagesManager.shared.showValidationError(errorMessage)
            return
        }
        
        view.endEditing(true)
        
        // TODO: استبدل بـ API حقيقي
        showLoadingState()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            NativeMessagesManager.shared.hide()
            self?.showSuccessMessage(email: email)
        }
    }
    
    private func showLoadingState() {
        NativeMessagesManager.shared.showLoading(
            title: "جاري إرسال رابط الاستعادة...",
            dimBackground: true
        )
        sendButton.isEnabled = false
    }
    
    private func showSuccessMessage(email: String) {
        HapticManager.shared.successImpact()
        
        // استخدام showSuccess بدلاً من showSuccessDialog
        NativeMessagesManager.shared.showSuccess(
            title: "تم الإرسال بنجاح",
            message: "تم إرسال رابط استعادة كلمة المرور إلى\n\(email)"
        )
        
        // الانتقال للشاشة السابقة بعد تأخير بسيط
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        sendButton.isEnabled = true
    }
    
    private func updateEmailFieldAppearance(isValid: Bool) {
        if isValid {
            mainView.layer.borderWidth = 1
            mainView.layer.borderColor = UIColor.systemGreen.cgColor
        } else if emailTextField.text?.isEmpty == false {
            mainView.layer.borderWidth = 1
            mainView.layer.borderColor = UIColor.systemRed.cgColor
        } else {
            mainView.layer.borderWidth = 0
        }
    }
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordVC: UITextFieldDelegate {
    
    // تم تغيير الاسم لتجنب التعارض
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if sendButton.isEnabled {
            sendButtonTapped()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("🖊 بدأ تحرير حقل البريد")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("✅ انتهى تحرير حقل البريد")
    }
}

// MARK: - Theme Support
extension ForgotPasswordVC {
    
    override func updateUIForCurrentTheme() {
        view.setBackgroundColor(.background)
        
        detailsLabel.textColor = AppColors.text.color
        
        emailTextField.backgroundColor = AppColors.secondBackground.color
        emailTextField.textColor = AppColors.text.color
        
        mainView.backgroundColor = AppColors.secondBackground.color
        
        updateButtonVisualState()
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

// MARK: - Cleanup
extension ForgotPasswordVC {
    
    private func cleanup() {
        emailTextField.delegate = nil
        removeThemeObserver()
        NativeMessagesManager.shared.hideAll()
    }
}
