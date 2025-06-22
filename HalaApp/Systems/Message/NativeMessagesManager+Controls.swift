//
//  NativeMessagesManager+Controls.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - Control Methods (التحكم في الرسائل)
extension NativeMessagesManager {
    
    /// إخفاء الرسالة الحالية
    func hide() {
        DispatchQueue.main.async {
            self.hideCurrentMessage()
        }
    }
    
    /// إخفاء الحوار الحالي
    func hideDialog() {
        DispatchQueue.main.async {
            self.hideCurrentDialog()
        }
    }
    
    /// إخفاء جميع الرسائل والحوارات
    func hideAll() {
        DispatchQueue.main.async {
            self.hideCurrentMessage()
            self.hideCurrentDialog()
        }
    }
    
    /// مسح قائمة انتظار الرسائل
    func clearQueue() {
        hideAll()
    }
    
    /// التحقق من وجود رسالة معروضة
    var hasActiveMessage: Bool {
        return currentMessageView != nil
    }
    
    /// التحقق من وجود حوار معروض
    var hasActiveDialog: Bool {
        return currentDialogView != nil
    }
    
    /// التحقق من وجود أي عرض نشط
    var hasActiveDisplay: Bool {
        return hasActiveMessage || hasActiveDialog
    }
}

// MARK: - Private Core Methods (الطرق الأساسية الداخلية)
extension NativeMessagesManager {
    
    /// عرض رسالة أساسية مع إعدادات مخصصة
    /// - Parameters:
    ///   - title: عنوان الرسالة
    ///   - message: نص الرسالة
    ///   - type: نوع الرسالة (نجاح، خطأ، تحذير، إلخ)
    ///   - configuration: إعدادات العرض
    func showMessage(title: String, message: String, type: MessageType, configuration: MessageConfiguration) {
        DispatchQueue.main.async {
            self.hideCurrentMessage()
            
            let messageView = self.createMessageView(
                title: title,
                message: message,
                type: type,
                configuration: configuration
            )
            
            self.presentMessage(messageView, configuration: configuration)
            
            // Haptic feedback
            if configuration.enableHaptic, let hapticType = type.hapticType {
                if let hapticManager = HapticManager.shared as? HapticManager {
                    hapticManager.performHaptic(for: hapticType)
                }
            }
            
            // إخفاء تلقائي - مع التحقق من الرسالة المعروضة
            if configuration.duration > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + configuration.duration) {
                    // التأكد من أن الرسالة المعروضة هي نفسها قبل الإخفاء
                    if self.currentMessageView == messageView {
                        self.hideCurrentMessage()
                    }
                }
            }
        }
    }
    
    /// إخفاء الرسالة الحالية مع تأثير بصري
    func hideCurrentMessage() {
        guard let messageView = currentMessageView else { return }
        
        UIView.animate(withDuration: DefaultSettings.animationDuration, animations: {
            messageView.alpha = 0
            messageView.transform = CGAffineTransform(translationX: 0, y: -100)
        }) { _ in
            messageView.removeFromSuperview()
            self.currentMessageView = nil
        }
    }
    
    /// إخفاء الحوار الحالي مع تأثير بصري
    func hideCurrentDialog() {
        guard let dialogView = currentDialogView else { return }
        
        UIView.animate(withDuration: DefaultSettings.animationDuration, animations: {
            dialogView.alpha = 0
            dialogView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.overlayWindow?.alpha = 0
        }) { _ in
            dialogView.removeFromSuperview()
            self.currentDialogView = nil
            self.overlayWindow?.isHidden = true
            self.overlayWindow = nil
        }
    }
}

// MARK: - Event Handlers (معالجات الأحداث)
extension NativeMessagesManager {
    
    /// معالج الضغط على الرسالة لإخفائها
    @objc func messageTapped() {
        hideCurrentMessage()
    }
    
    /// معالج الضغط على الخلفية المعتمة لإخفاء الحوار
    @objc func overlayTapped() {
        hideCurrentDialog()
    }
    
    /// تأثير الضغط على الزر
    @objc func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.alpha = 0.8
        }
    }
    
    /// إعادة الزر لحالته الطبيعية
    @objc func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
            sender.alpha = 1.0
        }
    }
}
