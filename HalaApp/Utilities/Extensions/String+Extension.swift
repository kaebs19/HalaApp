//
//  String+Extension.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//


import Foundation
import UIKit

extension String {
    
    // MARK: - Localization
    /// تحديث النص في اللغة
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    
    // MARK: - Email Validation
    /// التحقق من صحة البريد الإلكتروني
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    // MARK: - Password Validation
    /// التحقق من قوة كلمة المرور
    var isValidPassword: Bool {
        return self.count >= 6
    }
    
    /// التحقق من كلمة مرور قوية (8 أحرف + حروف كبيرة وصغيرة + أرقام)
    var isStrongPassword: Bool {
        let minLength = 8
        let hasUppercase = self.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = self.range(of: "[a-z]", options: .regularExpression) != nil
        let hasNumbers = self.range(of: "[0-9]", options: .regularExpression) != nil
        
        return self.count >= minLength && hasUppercase && hasLowercase && hasNumbers
    }
    
    // MARK: - Phone Validation
    /// التحقق من رقم الهاتف السعودي
    var isValidSaudiPhone: Bool {
        let phoneRegex = "^(\\+966|966|0)?[5][0-9]{8}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    /// التحقق من رقم الهاتف العام
    var isValidPhoneNumber: Bool {
        let phoneRegex = "^[+]?[0-9]{10,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    // MARK: - Text Validation
    /// التحقق من وجود نص
    var isNotEmpty: Bool {
        return !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// التحقق من الاسم (حروف فقط)
    var isValidName: Bool {
        let nameRegex = "^[a-zA-Zأ-ي\\s]{2,}$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: self)
    }
    
    // MARK: - URL Validation
    /// التحقق من صحة الرابط
    var isValidURL: Bool {
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    // MARK: - Formatting
    /// تنسيق رقم الهاتف السعودي
    var formattedSaudiPhone: String {
        let cleanPhone = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        if cleanPhone.hasPrefix("966") {
            return "+\(cleanPhone)"
        } else if cleanPhone.hasPrefix("0") {
            let withoutZero = String(cleanPhone.dropFirst())
            return "+966\(withoutZero)"
        } else if cleanPhone.count == 9 {
            return "+966\(cleanPhone)"
        }
        
        return self
    }
    
    /// إزالة المسافات الإضافية
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// تحويل لأحرف صغيرة مع إزالة المسافات
    var cleaned: String {
        return self.lowercased().trimmed
    }
}

// MARK: - Validation Result
extension String {
    
    /// نتيجة التحقق مع رسالة الخطأ
    enum ValidationResult {
        case valid
        case invalid(message: String)
        
        var isValid: Bool {
            switch self {
            case .valid:
                return true
            case .invalid:
                return false
            }
        }
        
        var errorMessage: String? {
            switch self {
            case .valid:
                return nil
            case .invalid(let message):
                return message
            }
        }
    }
    
    /// التحقق الشامل من البريد الإلكتروني مع رسالة مفصلة
    var emailValidationResult: ValidationResult {
        let trimmedEmail = self.trimmed
        
        if trimmedEmail.isEmpty {
            return .invalid(message: Alerts.email.texts)
        }
        
        if !trimmedEmail.isValidEmail {
            return .invalid(message: Alerts.invalidMail.texts)
        }
        
        return .valid
    }
    
    /// التحقق الشامل من كلمة المرور مع رسالة مفصلة
    var passwordValidationResult: ValidationResult {
        if self.isEmpty {
            return .invalid(message: Alerts.RequiredPassword.texts)
        }
        
        if self.count < 6 {
            return .invalid(message: "كلمة المرور يجب أن تكون 6 أحرف على الأقل")
        }
        
        return .valid
    }
    
    /// التحقق من كلمة المرور القوية
    var strongPasswordValidationResult: ValidationResult {
        if self.isEmpty {
            return .invalid(message: Alerts.RequiredPassword.texts)
        }
        
        if self.count < 8 {
            return .invalid(message: "كلمة المرور يجب أن تكون 8 أحرف على الأقل")
        }
        
        if !self.isStrongPassword {
            return .invalid(message: "كلمة المرور يجب أن تحتوي على حروف كبيرة وصغيرة وأرقام")
        }
        
        return .valid
    }
    
    /// التحقق الشامل من الاسم
    var nameValidationResult: ValidationResult {
        let trimmedName = self.trimmed
        
        if trimmedName.isEmpty {
            return .invalid(message: "الاسم مطلوب")
        }
        
        if trimmedName.count < 2 {
            return .invalid(message: "الاسم يجب أن يكون حرفين على الأقل")
        }
        
        if !trimmedName.isValidName {
            return .invalid(message: "الاسم يجب أن يحتوي على حروف فقط")
        }
        
        return .valid
    }
    
    /// التحقق الشامل من رقم الهاتف
    var phoneValidationResult: ValidationResult {
        let cleanPhone = self.trimmed
        
        if cleanPhone.isEmpty {
            return .invalid(message: "رقم الهاتف مطلوب")
        }
        
        if !cleanPhone.isValidSaudiPhone {
            return .invalid(message: "رقم الهاتف غير صحيح")
        }
        
        return .valid
    }
}
