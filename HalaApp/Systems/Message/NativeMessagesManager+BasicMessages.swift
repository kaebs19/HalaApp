//
//  NativeMessagesManager+BasicMessages.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - Basic Messages (متوافق مع MessagesManager القديم)

extension NativeMessagesManager {
    
    // MARK: - Success Messages
    /// عرض رسالة نجاح
    /// - Parameters:
    ///   - title: عنوان الرسالة
    ///   - message: نص الرسالة (اختياري)
    ///   - configuration: إعدادات العرض
    func showSuccess(title: String, message: String = "", configuration: MessageConfiguration = .default) {
        showMessage(title: title, message: message, type: .success, configuration: configuration)
    }
    
    /// عرض رسالة نجاح باستخدام النصوص المحفوظة
    func showSuccess(titleType: TitleMessage = .success, messageType: BodyMessage = .success, configuration: MessageConfiguration = .default) {
        showSuccess(title: titleType.title, message: messageType.textMessage, configuration: configuration)
    }
    
    // MARK: - Error Messages
    /// عرض رسالة خطأ
    func showError(title: String, message: String = "", configuration: MessageConfiguration = .default) {
        showMessage(title: title, message: message, type: .error, configuration: configuration)
    }
    
    /// عرض رسالة خطأ باستخدام النصوص المحفوظة
    func showError(titleType: TitleMessage = .error, messageType: BodyMessage = .failure, configuration: MessageConfiguration = .default) {
        showError(title: titleType.title, message: messageType.textMessage, configuration: configuration)
    }
    
    // MARK: - Warning Messages
    /// عرض رسالة تحذير
    func showWarning(title: String, message: String = "", configuration: MessageConfiguration = .default) {
        showMessage(title: title, message: message, type: .warning, configuration: configuration)
    }
    
    /// عرض رسالة تحذير باستخدام النصوص المحفوظة
    func showWarning(titleType: TitleMessage = .warning, messageType: BodyMessage = .fillAllFields, configuration: MessageConfiguration = .default) {
        showWarning(title: titleType.title, message: messageType.textMessage, configuration: configuration)
    }
    
    // MARK: - Info Messages
    /// عرض رسالة معلومات
    func showInfo(title: String, message: String = "", configuration: MessageConfiguration = .default) {
        showMessage(title: title, message: message, type: .info, configuration: configuration)
    }
    
    /// عرض رسالة معلومات باستخدام النصوص المحفوظة
    func showInfo(titleType: TitleMessage = .info, messageType: BodyMessage = .empty, configuration: MessageConfiguration = .default) {
        showInfo(title: titleType.title, message: messageType.textMessage, configuration: configuration)
    }
    
    // MARK: - Loading Messages
    /// عرض رسالة تحميل (لا تختفي تلقائياً)
    func showLoading(
        title: String = "جاري التحميل...",
                     message: String = "الرجاء الانتظار",
                     dimBackground: Bool = true ,
        autoDismiss: TimeInterval? = nil
    ) {
        var config = MessageConfiguration.default
        
        if let dismissTime = autoDismiss {
            config.duration = dismissTime // إخفاء تلقائي بعد الوقت المحدد
            config.isInteractive = true // قابل للمس للإخفاء اليدوي أيضاً
        } else {
            config.duration = -1 // لا تختفي تلقائياً (السلوك الافتراضي)
            config.isInteractive = false   // غير قابل للمس

        }
        
        config.dimBackground = dimBackground
        
        showMessage(title: title, message: message, type: .loading, configuration: config)
    }
    
    /// عرض رسالة تحميل باستخدام النصوص المحفوظة
    func showLoading(titleType: TitleMessage = .loading, messageType: BodyMessage = .pleaseWait, dimBackground: Bool = true) {
        showLoading(title: titleType.title, message: messageType.textMessage, dimBackground: dimBackground)
    }
    
    // MARK: - Custom Messages
    /// عرض رسالة مخصصة بألوان وأيقونة مخصصة
    func showCustom(title: String, message: String = "", backgroundColor: AppColors, textColor: AppColors = .buttonText, icon: UIImage? = nil, configuration: MessageConfiguration = .default) {
        let customType = MessageType.custom(backgroundColor: backgroundColor.color, textColor: textColor.color, icon: icon)
        showMessage(title: title, message: message, type: customType, configuration: configuration)
    }
}

// MARK: - Quick Methods (رسائل سريعة جاهزة)
extension NativeMessagesManager {
    
    /// عرض خطأ شبكة
    func showNetworkError() {
        showError(titleType: .networkError, messageType: .internetConnection)
    }
    
    /// عرض نجاح شبكة
    func showNetworkSuccess() {
        showSuccess(titleType: .success, messageType: .success)
    }
    
    /// عرض رسالة حفظ
    func showSaving() {
        showLoading(titleType: .saving, messageType: .pleaseWait, dimBackground: true)
    }
    
    /// عرض رسالة رفع ملفات
    func showUploading() {
        showLoading(titleType: .uploading, messageType: .pleaseWait, dimBackground: true)
    }
    
    /// عرض رسالة اتصال
    func showConnecting() {
        showLoading(titleType: .connecting, messageType: .pleaseWait, dimBackground: false)
    }
    
    /// عرض خطأ في التحقق من البيانات
    func showValidationError(_ message: String = "") {
        let bodyMessage = message.isEmpty ? BodyMessage.dataValidation.textMessage : message
        showWarning(title: TitleMessage.validation.title, message: bodyMessage)
    }
    
    /// عرض رسالة حقل مطلوب
    func showFieldRequired(_ fieldName: String) {
        showWarning(title: TitleMessage.required.title, message: "\(fieldName) مطلوب")
    }
    
    
}

