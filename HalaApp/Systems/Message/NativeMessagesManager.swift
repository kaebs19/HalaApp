//
//  NativeMessagesManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

/// مدير الرسائل الأصلي - البديل المحسن لـ MessagesManager
/// يوفر رسائل وحوارات بدون مكتبات خارجية مع تحكم كامل في المظهر والسلوك
class NativeMessagesManager {
    
    // MARK: - Singleton
    static let shared = NativeMessagesManager()
    private init() {}
    
    // MARK: - Properties
    internal var currentMessageView: UIView?
    internal var currentDialogView: UIView?
    internal var overlayWindow: UIWindow?
    
    // MARK: - Configuration
    internal struct DefaultSettings {
        static let animationDuration: TimeInterval = 0.3
        static let displayDuration: TimeInterval = 3.0
        static let cornerRadius: CGFloat = 12
        static let shadowOpacity: Float = 0.3
        static let messageHeight: CGFloat = 80
        static let horizontalMargin: CGFloat = 16
        static let verticalMargin: CGFloat = 8
    }
    
    
}

// MARK: - 📚 دليل الاستخدام السريع
/*
 
 🎯 كيفية الاستخدام:
 ==================
 
 1️⃣ الرسائل الأساسية:
 -------------------
 NativeMessagesManager.shared.showSuccess(title: "نجح!", message: "تم الحفظ")
 NativeMessagesManager.shared.showError(title: "خطأ!", message: "فشل الاتصال")
 NativeMessagesManager.shared.showWarning(title: "تحذير!", message: "تحقق من البيانات")
 NativeMessagesManager.shared.showInfo(title: "معلومة", message: "هذا تنبيه")
 
 2️⃣ رسائل التحميل:
 -----------------
 NativeMessagesManager.shared.showLoading() // تحميل عادي
 NativeMessagesManager.shared.showLoading(title: "جاري الحفظ...", dimBackground: true)
 NativeMessagesManager.shared.hide() // إخفاء التحميل
 
 3️⃣ الحوارات:
 -----------
 NativeMessagesManager.shared.showDialog(
     title: "تأكيد",
     message: "هل أنت متأكد؟",
     primaryButtonTitle: "نعم",
     secondaryButtonTitle: "لا",
     primaryAction: { print("نعم") },
     secondaryAction: { print("لا") }
 )
 
 4️⃣ Toast السريع:
 ----------------
 NativeMessagesManager.shared.showToast("تم النسخ!")
 NativeMessagesManager.shared.showSuccessToast("تم بنجاح")
 NativeMessagesManager.shared.showErrorToast("حدث خطأ")
 
 5️⃣ رسائل سريعة جاهزة:
 --------------------
 NativeMessagesManager.shared.showNetworkError() // خطأ شبكة
 NativeMessagesManager.shared.showFieldRequired("الاسم") // حقل مطلوب
 NativeMessagesManager.shared.showDeleteConfirmation { print("تم الحذف") }
 
 6️⃣ التحكم:
 ----------
 NativeMessagesManager.shared.hide() // إخفاء الرسالة
 NativeMessagesManager.shared.hideAll() // إخفاء كل شيء
 
 ⚠️ نصائح مهمة:
 ==============
 
 ✅ استخدم weak self في الإجراءات:
 primaryAction: { [weak self] in self?.doSomething() }
 
 ✅ نظف الرسائل في viewDidDisappear:
 override func viewDidDisappear(_ animated: Bool) {
     super.viewDidDisappear(animated)
     NativeMessagesManager.shared.hideAll()
 }
 
 ✅ للرسائل الطويلة، استخدم مدة أطول:
 var config = NativeMessagesManager.MessageConfiguration.default
 config.duration = 5.0
 NativeMessagesManager.shared.showInfo(title: "معلومة طويلة", configuration: config)
 
 */
