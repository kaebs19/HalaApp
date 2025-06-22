
//
//  NativeMessagesManager+Advanced.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - Advanced Features (الميزات المتقدمة)
extension NativeMessagesManager {
    
    // MARK: - Progress Messages
    /// عرض شريط التقدم
    /// - Parameters:
    ///   - title: عنوان العملية
    ///   - progress: نسبة التقدم (0.0 - 1.0)
    ///   - animated: تفعيل الحركة
    func showProgress(title: String, progress: Float, animated: Bool = true) {
        DispatchQueue.main.async {
            self.hideCurrentMessage()
            
            let progressView = self.createProgressView(title: title, progress: progress, animated: animated)
            var config = MessageConfiguration.default
            config.duration = -1 // لا تختفي تلقائياً
            config.isInteractive = false
            
            self.presentMessage(progressView, configuration: config)
        }
    }
    
    /// تحديث شريط التقدم
    /// - Parameters:
    ///   - progress: النسبة الجديدة (0.0 - 1.0)
    ///   - animated: تفعيل الحركة
    func updateProgress(_ progress: Float, animated: Bool = true) {
        guard let messageView = currentMessageView,
              let progressBar = messageView.viewWithTag(999) as? UIProgressView,
              let progressLabel = messageView.viewWithTag(998) as? UILabel else { return }
        
        DispatchQueue.main.async {
            progressBar.setProgress(progress, animated: animated)
            progressLabel.text = "\(Int(progress * 100))%"
        }
    }
    
    // MARK: - Enhanced Toast Messages
    /// عرض Toast بسيط
    /// - Parameters:
    ///   - message: نص الرسالة
    ///   - duration: مدة العرض (بالثواني)
    ///   - position: موضع العرض
    func showToast(_ message: String, duration: TimeInterval = 2.0, position: Position = .bottom) {
        DispatchQueue.main.async {
            let toastView = self.createEnhancedToastView(message: message)
            var config = MessageConfiguration.default
            config.duration = duration
            config.position = position
            config.enableHaptic = false // Toast عادة بدون اهتزاز
            
            self.presentMessage(toastView, configuration: config)
        }
    }
    
    /// Toast مع أيقونة مخصصة
    func showToastWithIcon(_ message: String, icon: UIImage?, duration: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            let toastView = self.createToastWithIconView(message: message, icon: icon)
            var config = MessageConfiguration.default
            config.duration = duration
            config.position = .bottom
            
            self.presentMessage(toastView, configuration: config)
        }
    }
    
    /// Toast للنجاح مع أيقونة
    func showSuccessToast(_ message: String) {
        showToastWithIcon(message, icon: UIImage(systemName: "checkmark.circle.fill"))
    }
    
    /// Toast للخطأ مع أيقونة
    func showErrorToast(_ message: String) {
        showToastWithIcon(message, icon: UIImage(systemName: "xmark.circle.fill"))
    }
    
    /// Toast للتحذير مع أيقونة
    func showWarningToast(_ message: String) {
        showToastWithIcon(message, icon: UIImage(systemName: "exclamationmark.triangle.fill"))
    }
    
    /// Toast للمعلومات مع أيقونة
    func showInfoToast(_ message: String) {
        showToastWithIcon(message, icon: UIImage(systemName: "info.circle.fill"))
    }
    
    // MARK: - Notification Messages
    /// عرض إشعار تفاعلي
    /// - Parameters:
    ///   - title: عنوان الإشعار
    ///   - message: نص الإشعار
    ///   - icon: أيقونة الإشعار
    ///   - actionTitle: نص زر الإجراء
    ///   - action: إجراء الزر
    func showNotification(
        title: String,
        message: String,
        icon: UIImage? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            let notificationView = self.createNotificationView(
                title: title,
                message: message,
                icon: icon,
                actionTitle: actionTitle,
                action: action
            )
            
            var config = MessageConfiguration.default
            config.duration = 5.0
            config.position = .top
            
            self.presentMessage(notificationView, configuration: config)
        }
    }
    
    // MARK: - Action Messages
    /// عرض رسالة مع أزرار إجراءات متعددة
    /// - Parameters:
    ///   - title: عنوان الرسالة
    ///   - message: نص الرسالة
    ///   - actions: قائمة الإجراءات المتاحة
    func showActionMessage(
        title: String,
        message: String,
        actions: [(title: String, style: UIAlertAction.Style, handler: () -> Void)]
    ) {
        DispatchQueue.main.async {
            let actionView = self.createActionMessageView(
                title: title,
                message: message,
                actions: actions
            )
            
            var config = MessageConfiguration.default
            config.duration = -1 // لا تختفي تلقائياً
            config.position = .center
            config.dimBackground = true
            
            self.presentMessage(actionView, configuration: config)
        }
    }
    
    // MARK: - Sequential Messages
    /// عرض رسائل متتالية
    /// - Parameters:
    ///   - messages: قائمة الرسائل
    ///   - delay: التأخير بين الرسائل
    func showSequentialMessages(_ messages: [(title: String, message: String, type: MessageType)], delay: TimeInterval = 0.5) {
        for (index, messageData) in messages.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + (delay * Double(index))) {
                self.showMessage(
                    title: messageData.title,
                    message: messageData.message,
                    type: messageData.type,
                    configuration: .default
                )
            }
        }
    }
}
