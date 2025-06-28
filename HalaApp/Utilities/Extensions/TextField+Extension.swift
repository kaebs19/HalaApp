//
//  TextField+Extension.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 11/06/2025.
//

import UIKit


extension UITextField {
    
    /// إعداد TextField مخصص مع دعم الثيمات
    func setupCustomTextField(placeholder: Placeholders = .empty,
                              textColor: AppColors = .text,
                              placeholderColor: AppColors = .placeholder,
                              font: Fonts = .cairo ,
                              fontStyle: FontStyle = .semiBold,
                              ofSize: Sizes = .size_16 ,
                              padding: UIEdgeInsets =  UIEdgeInsets(top: 12, left: 16, bottom:12, right: 16 ),
                              autoTemeUpdate: Bool = true,
                              keyboardType: UIKeyboardType? = nil,
                              returnKeyType:UIReturnKeyType? = nil
                                ){
        
        // النص والخط
        self.textColor = textColor.color
        self.font = FontManager.shared.fontApp(family: font, style: fontStyle, size: ofSize)
        
        // Placeholder مخصص
        if  placeholder != .empty  {
            self.attributedPlaceholder =
            NSAttributedString(string: placeholder.PlaceholderText ,
                                                            attributes: [
                                                                .foregroundColor: placeholderColor.color,
                                                                .font: FontManager.shared.fontApp(family: font, style: .regular, size: ofSize)
                                                            ])
        }
        
        // إعدادات الكيبورد (إذا تم تحديدها)
        if let keyboardType = keyboardType {
            self.keyboardType = keyboardType
        }
        
        if let returnKeyType = returnKeyType {
            self.returnKeyType = returnKeyType
        }
        
        // إعدادات المظهر العامة
        setupTextFieldAppearance()
        
        // تسجيل للتحديثات التلقائية للثيم
        if autoTemeUpdate {
            registerForThemeUpdates(
                textColor: textColor,
                placeholderColor: placeholderColor,
                font: font,
                fontStyle: fontStyle,
                ofSize: ofSize
            )
        }

    }
    
    
    /// إعداد المسافات الداخلية
    private func setupTextFieldPadding(_ padding: UIEdgeInsets) {
        let paddingView = PaddedTextField.PaddingView(padding: padding)
        leftView = paddingView
        leftViewMode = .always
        rightView = PaddedTextField.PaddingView(padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: padding.right))
        rightViewMode = .always
    }
    
    /// إعدادات المظهر العامة
    private func setupTextFieldAppearance() {
        backgroundColor = .clear
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
        
        // إعدادات النص
        autocorrectionType = .no
        spellCheckingType = .no
        adjustsFontForContentSizeCategory = true
        clipsToBounds = true
    }

    /// تسجيل لتحديثات الثيم التلقائية
    private func registerForThemeUpdates(
        textColor: AppColors,
        placeholderColor: AppColors,
        font: Fonts,
        fontStyle: FontStyle,
        ofSize: Sizes
    ) {
        // حفظ الألوان والخط كخصائص مرتبطة
        objc_setAssociatedObject(self, &AssociatedKeys.textColor, textColor, .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(self, &AssociatedKeys.placeholderColor, placeholderColor, .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(self, &AssociatedKeys.font, font, .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(self, &AssociatedKeys.fontStyle, fontStyle, .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(self, &AssociatedKeys.fontSize, ofSize, .OBJC_ASSOCIATION_RETAIN)
        
        // الاشتراك في تحديثات الثيم
        NotificationCenter.default.addObserver(
            forName: .themeDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refreshThemeColors()
        }
    }
    
    

    
    /// تحديث الألوان عند تغيير الثيم
    @objc private func refreshThemeColors() {
        guard let textColor = objc_getAssociatedObject(self, &AssociatedKeys.textColor) as? AppColors,
              let placeholderColor = objc_getAssociatedObject(self, &AssociatedKeys.placeholderColor) as? AppColors,
              let font = objc_getAssociatedObject(self, &AssociatedKeys.font) as? Fonts,
              let fontSize = objc_getAssociatedObject(self, &AssociatedKeys.fontSize) as? Sizes else {
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            // تحديث لون النص
            self.textColor = textColor.color
            
            // تحديث placeholder
            if let currentPlaceholder = self.placeholder {
                self.attributedPlaceholder = NSAttributedString(
                    string: currentPlaceholder,
                    attributes: [
                        .foregroundColor: placeholderColor.color,
                        .font: FontManager.shared.fontApp(family: font, style: .regular, size: fontSize)
                    ]
                )
            }
        }
    }

}


// MARK: - Validation & States
extension UITextField {
    
    /// حالات TextField المبسطة
    enum TextFieldState {
        case normal
        case focused
        case error
        case success
        case disabled
        
        var textColor: AppColors {
            switch self {
            case .normal, .focused: return .text
            case .error: return .error
            case .success: return .success
            case .disabled: return .textSecondary
            }
        }
    }
    
    /// تطبيق حالة معينة على TextField (مبسط - لون النص فقط)
    func applyState(_ state: TextFieldState, animated: Bool = true) {
        let textColor = state.textColor.color
        isEnabled = state != .disabled
        
        let applyChanges = {
            self.textColor = textColor
        }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: applyChanges)
        } else {
            applyChanges()
        }
    }
    
    /// validation مبسط مع تأثيرات بصرية
    func validateAndShowState(isValid: Bool, errorMessage: String? = nil) {
        applyState(isValid ? .success : .error)
        
        if !isValid {
            addShakeAnimation()
            
            // إضافة رسالة خطأ (اختياري)
            if let error = errorMessage {
                NativeMessagesManager.shared.showError(title: error)
            }
        }
    }
    
    /// تأثير اهتزاز للخطأ
    private func addShakeAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-10.0, 10.0, -8.0, 8.0, -6.0, 6.0, -4.0, 4.0, 0.0]
        layer.add(animation, forKey: "shake")
        
        // Haptic feedback
        let impactGenerator = UINotificationFeedbackGenerator()
        impactGenerator.notificationOccurred(.error)
    }
}


// MARK: - Focus Management
extension UITextField {
    
    /// إضافة تأثيرات Focus/Blur
    func addFocusEffects() {
        addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }
    
    @objc private func textFieldDidBeginEditing() {
        applyState(.focused)
    }
    
    @objc private func textFieldDidEndEditing() {
        applyState(.normal)
    }
}


// MARK: - Convenience Methods
extension UITextField {
    
    /// إعداد سريع لـ Email
    func setupAsEmailField(
        placeholder: Placeholders = .email,
        textColor: AppColors = .text,
        font: Fonts = .cairo,
        ofSize: Sizes = .size_16
    ) {
        setupCustomTextField(
            placeholder: placeholder,
            textColor: textColor,
            font: font,
            ofSize: ofSize
        )
        
        keyboardType = .emailAddress
        textContentType = .emailAddress
        autocapitalizationType = .none
        addFocusEffects()
    }
    
    /// إعداد سريع لـ Password
    func setupAsPasswordField(
        placeholder: Placeholders = .password,
        textColor: AppColors = .text,
        font: Fonts = .cairo,
        ofSize: Sizes = .size_16
    ) {
        setupCustomTextField(
            placeholder: placeholder,
            textColor: textColor,
            font: font,
            ofSize: ofSize
        )
        
        isSecureTextEntry = true
        textContentType = .password
        addFocusEffects()
    }
    
    /// إعداد سريع لـ Name
    func setupAsNameField(
        placeholder: Placeholders = .name,
        textColor: AppColors = .text,
        font: Fonts = .cairo,
        ofSize: Sizes = .size_16
    ) {
        setupCustomTextField(
            placeholder: placeholder,
            textColor: textColor,
            font: font,
            ofSize: ofSize
        )
        
        textContentType = .name
        autocapitalizationType = .words
        addFocusEffects()
    }
    
    /// إعداد عام (الأبسط)
    func setupBasic(
        placeholder: Placeholders,
        textColor: AppColors = .text
    ) {
        setupCustomTextField(
            placeholder: placeholder,
            textColor: textColor
        )
        addFocusEffects()
    }
}





// MARK: - Supporting Classes
private class PaddedTextField {
    class PaddingView: UIView {
        let padding: UIEdgeInsets
        
        init(padding: UIEdgeInsets) {
            self.padding = padding
            super.init(frame: CGRect(x: 0, y: 0, width: padding.left + padding.right, height: padding.top + padding.bottom))
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}



// MARK: - Associated Keys
private struct AssociatedKeys {
    static var textColor = "textColor"
    static var placeholderColor = "placeholderColor"
    static var font = "font"
    static var fontStyle = "fontStyle"
    static var fontSize = "fontSize"
    static var emailCheckIcon = "emailCheckIcon"

}


extension UITextField {

    /// تحديث مؤشر صحة البريد الإلكتروني
    func updateEmailValidationIndicator(isValid: Bool) {
        guard let checkIcon = objc_getAssociatedObject(self, &AssociatedKeys.emailCheckIcon) as? UIImageView else { return }
        
        UIView.animate(withDuration: 0.3) {
            checkIcon.isHidden = !isValid
            checkIcon.transform = isValid ?
                CGAffineTransform(scaleX: 1.2, y: 1.2) : .identity
        } completion: { _ in
            if isValid {
                UIView.animate(withDuration: 0.2) {
                    checkIcon.transform = .identity
                }
            }
        }
    }
    
    // MARK: - Validation Border
    
    
    /// إعداد حقل السنة مع لوحة مفاتيح رقمية
    func setupAsYearField(
        placeholder: Placeholders,
        textColor: AppColors = .text,
        placeholderColor: AppColors = .placeholder,
        font: Fonts = .cairo,
        ofSize: Sizes = .size_16
    ) {
        // الإعداد الأساسي
        self.textColor = textColor.color
        self.font = FontManager.shared.fontApp(family: font, style: .medium, size: ofSize)
        
        // Placeholder
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder.PlaceholderText,
            attributes: [
                .foregroundColor: placeholderColor.color,
                .font: FontManager.shared.fontApp(family: font, style: .regular, size: ofSize)
            ]
        )
        
        // إعدادات لوحة المفاتيح
        self.keyboardType = .numberPad
        self.textContentType = .none
        
        // منع النسخ واللصق للنصوص غير الرقمية
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        
        // تحديد الحد الأقصى لعدد الأحرف
        self.addTarget(self, action: #selector(limitYearInput), for: .editingChanged)
        
        // إعدادات المظهر
        self.backgroundColor = .clear
        self.layer.borderWidth = 0
        self.textAlignment = Directions.auto.textAlignment
    }
    
    @objc private func limitYearInput() {
        // تحديد الحد الأقصى بـ 4 أرقام
        if let text = self.text, text.count > 4 {
            self.text = String(text.prefix(4))
        }
    }


}


// MARK: - أمثلة الاستخدام
/*
 
 // استخدام عادي بدون تحديد نوع الكيبورد
 emailField.setupCustomTextField(
     placeholder: .email
 )
 
 // استخدام مع تحديد نوع الكيبورد فقط
 emailField.setupCustomTextField(
     placeholder: .email,
     keyboardType: .emailAddress
 )
 
 // استخدام مع تحديد زر Return فقط
 passwordField.setupCustomTextField(
     placeholder: .password,
     returnKeyType: .done
 )
 
 // استخدام مع تحديد الاثنين
 phoneField.setupCustomTextField(
     placeholder: .phone,
     keyboardType: .phonePad,
     returnKeyType: .done
 )
 
 */
