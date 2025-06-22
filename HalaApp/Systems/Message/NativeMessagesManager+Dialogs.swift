//
//  NativeMessagesManager+Dialogs.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - Dialog Methods (الحوارات التفاعلية)
extension NativeMessagesManager {
    
    // MARK: - Basic Dialog
    
    /// عرض حوار مع زرين
    /// - Parameters:
    ///   - title: عنوان الحوار
    ///   - message: نص الحوار
    ///   - primaryButtonTitle: نص الزر الأساسي
    ///   - secondaryButtonTitle: نص الزر الثانوي (اختياري)
    ///   - primaryAction: إجراء الزر الأساسي
    ///   - secondaryAction: إجراء الزر الثانوي (اختياري)
    func showDialog(
        title: String,
        message: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            self.hideCurrentDialog()
            
            let dialogView = self.createDialogView(
                title: title,
                message: message,
                primaryButtonTitle: primaryButtonTitle,
                secondaryButtonTitle: secondaryButtonTitle,
                primaryAction: primaryAction,
                secondaryAction: secondaryAction
            )
            
            self.presentDialog(dialogView)
            
            // Haptic feedback
            if let hapticManager = HapticManager.shared as? HapticManager {
                hapticManager.performHaptic(for: .warning)
            }
        }
    }
    
    // MARK: - Convenience Dialogs
    /// حوار تأكيد الحذف الجاهز
    func showDeleteConfirmation(onConfirm: @escaping () -> Void, onCancel: (() -> Void)? = nil) {
        showDialog(
            title: TitleMessage.confirmDelete.title,
            message: BodyMessage.deleteConfirmation.textMessage,
            primaryButtonTitle: Alerts.Delete.texts,
            secondaryButtonTitle: Alerts.cancel.texts,
            primaryAction: onConfirm,
            secondaryAction: onCancel
        )
    }
    
    /// حوار التحديث الجاهز
    func showUpdateDialog(onUpdate: @escaping () -> Void, onSkip: (() -> Void)? = nil) {
        showDialog(
            title: TitleMessage.updateAvailable.title,
            message: BodyMessage.updateDescription.textMessage,
            primaryButtonTitle: Alerts.Refresh.texts,
            secondaryButtonTitle: Alerts.Skip.texts,
            primaryAction: onUpdate,
            secondaryAction: onSkip
        )
    }
    
    /// حوار تسجيل الخروج
    func showLogoutConfirmation(onLogout: @escaping () -> Void, onCancel: (() -> Void)? = nil) {
        showDialog(
            title: "تسجيل الخروج",
            message: "هل أنت متأكد من تسجيل الخروج من التطبيق؟",
            primaryButtonTitle: "تسجيل الخروج",
            secondaryButtonTitle: "إلغاء",
            primaryAction: onLogout,
            secondaryAction: onCancel
        )
    }
    
    /// حوار حفظ التغييرات
    func showSaveChangesDialog(onSave: @escaping () -> Void, onDiscard: @escaping () -> Void, onCancel: (() -> Void)? = nil) {
        showActionMessage(
            title: "حفظ التغييرات",
            message: "لديك تغييرات غير محفوظة، ماذا تريد أن تفعل؟",
            actions: [
                ("حفظ", .default, onSave),
                ("تجاهل", .destructive, onDiscard),
                ("إلغاء", .cancel, { onCancel?() })
            ]
        )
    }
}
