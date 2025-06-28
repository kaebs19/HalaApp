//
//  IQKeyboardManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 26/06/2025.

import UIKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import IQKeyboardReturnManager
import IQTextView

// MARK: - IQKeyboardManager Extension
extension IQKeyboardManager {
    
    /// الإعداد الأساسي للكيبورد
    /// يتم استدعاؤه مرة واحدة في AppDelegate
    static func setupDefault() {
        // إعدادات IQKeyboardManager الأساسية
        let keyboardManager = IQKeyboardManager.shared
        keyboardManager.isEnabled = true
        keyboardManager.resignOnTouchOutside = true
        keyboardManager.keyboardDistance = 10
        
        // إعدادات IQKeyboardToolbarManager
        let toolbarManager = IQKeyboardToolbarManager.shared
        toolbarManager.isEnabled = true
        
        // تخصيص شريط الأدوات
        setupToolbarConfiguration()
        
        // التخصيص حسب الجهاز
        setupForDeviceType()
        
        // تخصيص الألوان
        setupColors()
    }
    
    /// إعداد تكوين شريط الأدوات
    private static func setupToolbarConfiguration() {
        let toolbarManager = IQKeyboardToolbarManager.shared
        
        // إعدادات العرض
        toolbarManager.toolbarConfiguration.placeholderConfiguration.showPlaceholder = true
        toolbarManager.toolbarConfiguration.previousNextDisplayMode = .alwaysShow
        toolbarManager.toolbarConfiguration.manageBehavior = .bySubviews
        
        
        
        // تخصيص placeholder
        toolbarManager.toolbarConfiguration.placeholderConfiguration.font = UIFont.systemFont(ofSize: 14)

        // الأصوات
        toolbarManager.playInputClicks = true
    }
    
    /// إعداد خاص بنوع الجهاز
    private static func setupForDeviceType() {
        let keyboardManager = IQKeyboardManager.shared
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // إعدادات الايباد
            keyboardManager.keyboardDistance = 20
            keyboardManager.resignOnTouchOutside = false
        } else {
            // إعدادات الايفون
            keyboardManager.keyboardDistance = 10
            keyboardManager.resignOnTouchOutside = true
        }
    }
    
    /// تخصيص الألوان
    private static func setupColors() {
        let toolbarManager = IQKeyboardToolbarManager.shared
        
        // استخدام ألوان النظام
        toolbarManager.toolbarConfiguration.useTextInputViewTintColor = false
        
        if #available(iOS 13.0, *) {
            toolbarManager.toolbarConfiguration.tintColor = .label
            toolbarManager.toolbarConfiguration.barTintColor = .systemBackground
            toolbarManager.toolbarConfiguration.placeholderConfiguration.color = .placeholderText
        } else {
            toolbarManager.toolbarConfiguration.tintColor = .darkText
            toolbarManager.toolbarConfiguration.barTintColor = .white
            toolbarManager.toolbarConfiguration.placeholderConfiguration.color = .lightGray
        }
    }
    
    /// تعطيل الكيبورد مؤقتاً
    static func disable() {
        IQKeyboardManager.shared.isEnabled = false
        IQKeyboardToolbarManager.shared.isEnabled = false
    }
    
    /// إعادة تفعيل الكيبورد
    static func enable() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.isEnabled = true
    }
    
    /// استثناء ViewController من إدارة المسافة
    static func excludeViewController(_ viewController: UIViewController.Type) {
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(viewController)
    }
    
    /// استثناء ViewController من شريط الأدوات
    static func excludeToolbarForViewController(_ viewController: UIViewController.Type) {
        IQKeyboardToolbarManager.shared.disabledToolbarClasses.append(viewController)
    }
}


// MARK: - UIViewController Extension
extension UIViewController {
    
    /// إعداد IQKeyboardReturnManager للتنقل بين الحقول
    /// - Parameters:
    ///   - textFields: مصفوفة الحقول النصية بالترتيب المطلوب
    ///   - dismissTextViewOnReturn: إخفاء الكيبورد من UITextView
    ///   - lastReturnKeyType: نوع زر Return في آخر حقل
    func setupIQKeyboardReturnManager(
        textFields: [UITextField],
        dismissTextViewOnReturn: Bool = true,
        lastReturnKeyType: UIReturnKeyType = .done
    ) {
        // إنشاء instance من ReturnManager
        let returnManager = IQKeyboardReturnManager()
        
        // إضافة الحقول بالترتيب
        textFields.forEach { textField in
            returnManager.add(textInputView: textField)
        }
        
        // إعدادات ReturnManager
        returnManager.dismissTextViewOnReturn = dismissTextViewOnReturn
        returnManager.lastTextInputViewReturnKeyType = lastReturnKeyType
        
        // حفظ reference للـ manager (اختياري)
        objc_setAssociatedObject(self, &AssociatedKeys.returnManagerKey, returnManager, .OBJC_ASSOCIATION_RETAIN)
        
        print("✅ تم إعداد IQKeyboardReturnManager مع \(textFields.count) حقل")
    }
    
    /// إعداد شامل للشاشة مع IQKeyboard (محدث)
    func setupScreenWithIQKeyboard(
        textFields: [UITextField] = [],
        dismissOnTap: Bool = true,
        makeResponsive: Bool = true,
        useReturnManager: Bool = true
    ) {
        // إعداد الحقول النصية
        if !textFields.isEmpty {
            setupTextFieldsWithIQ(textFields)
            
            // استخدام ReturnManager إذا مطلوب
            if useReturnManager {
                setupIQKeyboardReturnManager(textFields: textFields)
            }
        }
        
        // إضافة إيماءة إخفاء الكيبورد
        if dismissOnTap {
            setupDismissKeyboardGesture()
        }
        
        // تطبيق التجاوب
        if makeResponsive {
            self.makeResponsive()
        }
    }

    
    /// تعطيل IQKeyboardManager لهذا الـ ViewController
    func disableIQKeyboard() {
        IQKeyboardManager.excludeViewController(type(of: self))
    }
    
    /// تعطيل شريط الأدوات فقط
    func disableIQToolbar() {
        IQKeyboardManager.excludeToolbarForViewController(type(of: self))
    }
    
    /// إخفاء الكيبورد
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    /// إضافة إيماءة لإخفاء الكيبورد عند اللمس خارج الحقول
    func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboardOnTap() {
        hideKeyboard()
    }
    
    /// إعداد مجموعة حقول نصية مع IQKeyboard
    func setupTextFieldsWithIQ(_ textFields: [UITextField]) {
        // IQKeyboard يتعامل تلقائياً مع التنقل
        // لكن يمكننا تخصيص returnKeyType
        for (index, textField) in textFields.enumerated() {
            if index < textFields.count - 1 {
                textField.returnKeyType = .next
            } else {
                textField.returnKeyType = .done
            }
        }
    }
    

    
    /// التعامل مع التنقل بين الحقول عند الضغط على Return
    @objc private func textFieldShouldReturns(_ textField: UITextField) {
        guard let textFields = objc_getAssociatedObject(self, &AssociatedKeys.textFieldsKey) as? [UITextField] else { return }
        
        let currentIndex = textField.tag
        
        if currentIndex < textFields.count - 1 {
            // الانتقال للحقل التالي
            textFields[currentIndex + 1].becomeFirstResponder()
        } else {
            // إخفاء الكيبورد في آخر حقل
            textField.resignFirstResponder()
        }
    }
    
    /// إعداد شامل للشاشة مع IQKeyboard
    func setupScreenWithIQKeyboard(
        textFields: [UITextField] = [],
        dismissOnTap: Bool = true,
        makeResponsive: Bool = true
    ) {
        // إعداد الحقول النصية
        if !textFields.isEmpty {
            setupTextFieldsWithIQ(textFields)
        }
        
        // إضافة إيماءة إخفاء الكيبورد
        if dismissOnTap {
            setupDismissKeyboardGesture()
        }
        
        // تطبيق التجاوب
        if makeResponsive {
            self.makeResponsive()
        }
    }
}

// MARK: - Associated Keys
private struct AssociatedKeys {
    static var textFieldsKey = "textFieldsKey"
    static var returnManagerKey = "returnManagerKey"
}

// MARK: - أمثلة الاستخدام
/*
 
 // في AppDelegate:
 import IQKeyboardManagerSwift
 import IQKeyboardToolbarManager
 
 func application(_ application: UIApplication, didFinishLaunchingWithOptions...) -> Bool {
     IQKeyboardManager.setupDefault()
     return true
 }
 
 // في ViewController:
 class LoginViewController: UIViewController {
     @IBOutlet weak var emailField: UITextField!
     @IBOutlet weak var passwordField: UITextField!
     @IBOutlet weak var loginButton: UIButton!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         // إعداد شامل للشاشة
         setupScreenWithIQKeyboard(
             textFields: [emailField, passwordField],
             dismissOnTap: true,
             makeResponsive: true
         )
         
         // إعداد الحقول النصية
         emailField.setupAsEmailFieldWithIQ()
         passwordField.setupAsPasswordFieldWithIQ()
         
         // إعداد الزر
         loginButton.setupWithKeyboardDismiss(
             title: .login,
             titleColor: .buttonText,
             backgroundColor: .primary,
             dismissKeyboard: true
         )
     }
 }
 
 // مثال لشاشة التسجيل:
 class RegisterViewController: UIViewController {
     @IBOutlet weak var nameField: UITextField!
     @IBOutlet weak var emailField: UITextField!
     @IBOutlet weak var phoneField: UITextField!
     @IBOutlet weak var passwordField: UITextField!
     @IBOutlet weak var bioTextView: UITextView!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         // إعداد شامل
         setupScreenWithIQKeyboard(
             textFields: [nameField, emailField, phoneField, passwordField]
         )
         
         // إعداد الحقول
         nameField.setupAsNameFieldWithIQ()
         emailField.setupAsEmailFieldWithIQ()
         phoneField.setupAsPhoneFieldWithIQ()
         passwordField.setupAsPasswordFieldWithIQ()
         
         // إعداد TextView
         bioTextView.setupWithIQKeyboard(
             placeholder: "اكتب نبذة عن نفسك",
             ofSize: .size_14
         )
     }
 }
 
 // لتعطيل IQKeyboard في شاشة معينة (مثل المحادثة):
 class ChatViewController: UIViewController {
     override func viewDidLoad() {
         super.viewDidLoad()
         disableIQKeyboard()
     }
 }
 
 // التحقق من إمكانية التنقل:
 func checkNavigation() {
     if IQKeyboardToolbarManager.shared.canGoPrevious {
         print("يمكن العودة للحقل السابق")
     }
     
     if IQKeyboardToolbarManager.shared.canGoNext {
         print("يمكن الانتقال للحقل التالي")
     }
 }
 
 */
