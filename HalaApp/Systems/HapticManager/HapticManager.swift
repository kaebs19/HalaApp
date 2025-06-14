//
//  HapticManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 14/06/2025.
//

import Foundation
import UIKit

/// إدارة الاهتزازات التفاعلية في التطبيق
class HapticManager {
    
    // MARK: - Singleton
    static let shared = HapticManager()
    private init() {
        setupNotificationObserver()
    }
    
    // MARK: - Private Properties
    private var isObservingSettings = false

    
    // MARK: - Impact Feedback
    
    /// اهتزاز خفيف - للتفاعلات البسيطة
    func lightImpact() {
        guard isHapticEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// اهتزاز متوسط - للتفاعلات المتوسطة
    func mediumImpact() {
        guard isHapticEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// اهتزاز قوي - للتفاعلات المهمة
    func heavyImpact() {
        guard isHapticEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    // MARK: - Notification Feedback
    
    /// اهتزاز النجاح - عند إتمام عملية بنجاح
    func successImpact() {
        guard isHapticEnabled else { return }
        
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    /// اهتزاز التحذير - عند وجود تحذير
    func warningImpact() {
        guard isHapticEnabled else { return }
        
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
    }
    
    /// اهتزاز الخطأ - عند حدوث خطأ
    func errorImpact() {
        guard isHapticEnabled else { return }
        
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
    
    // MARK: - Selection Feedback
    
    /// اهتزاز التحديد - عند تغيير الاختيار (iOS 13+)
    @available(iOS 13.0, *)
    func selectionImpact() {
        guard isHapticEnabled else { return }
        
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    // MARK: - Custom Patterns
    
    /// اهتزاز مخصص للتفاعل العام
    func interactionImpact() {
        if #available(iOS 13.0, *) {
            selectionImpact()
        } else {
            lightImpact()
        }
    }
    
    /// اهتزاز للضغط على الأزرار
    func buttonTapImpact() {
        lightImpact()
    }
    
    /// اهتزاز لتفعيل/تعطيل الخيارات
    func toggleImpact() {
        mediumImpact()
    }
    
    /// اهتزاز لبداية عملية مهمة
    func actionStartImpact() {
        heavyImpact()
    }
    
    /// اهتزاز لتأكيد العمليات
    func confirmationImpact() {
        successImpact()
    }
    
    /// اهتزاز للتنبيهات
    func alertImpact() {
        warningImpact()
    }
    
    /// اهتزاز لرفض العمليات
    func rejectionImpact() {
        errorImpact()
    }
    
    // MARK: - Complex Patterns
    
    /// نمط اهتزاز مركب للعمليات المعقدة
    func complexSuccessPattern() {
        guard isHapticEnabled else { return }
        
        lightImpact()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.mediumImpact()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.successImpact()
        }
    }
    
    /// نمط اهتزاز للأخطاء المتتالية
    func multipleErrorPattern() {
        guard isHapticEnabled else { return }
        
        errorImpact()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.errorImpact()
        }
    }
    
    /// نمط اهتزاز للتحديد المتعدد
    func multiSelectionPattern() {
        guard isHapticEnabled else { return }
        
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                self.lightImpact()
            }
        }
    }
    
    // MARK: - Settings & Control
    
    /// تحقق من تفعيل الاهتزاز في الإعدادات
    private var isHapticEnabled: Bool {
        // يمكنك ربطها بإعدادات التطبيق
        return UserDefault.shared.hapticEnabled  && isHapticSupported
    }
    
    /// تفعيل/تعطيل الاهتزاز
    func setHapticEnabled(_ enabled: Bool) {
        UserDefault.shared.hapticEnabled = true
        
        // إشعار بتغيير الإعدادات
        NotificationCenter.default.post(
            name: .hapticSettingsChanged,
            object: enabled
        )
        print("🎮 تم \(enabled ? "تفعيل" : "تعطيل") الاهتزاز التفاعلي")

    }
    
    /// التحقق من دعم الجهاز للاهتزاز
    var isHapticSupported: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var currentHapticState: Bool {
        return isHapticEnabled
    }
    
    // MARK: - Notification Observer
    private func setupNotificationObserver() {
        guard !isObservingSettings else { return }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hapticSettingsDidChange(_:)),
            name: .hapticSettingsChanged,
            object: nil
        )
        
        isObservingSettings = true
    }
    
    @objc private func hapticSettingsDidChange(_ notification: Notification) {
        if let isEnabled = notification.object as? Bool {
            print("📳 تم تحديث إعدادات الاهتزاز: \(isEnabled ? "مفعل" : "معطل")")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    
    // MARK: - Convenience Methods
    
    /// تطبيق الاهتزاز المناسب حسب نوع العملية
    func performHaptic(for feedbackType: HapticFeedbackType) {
        switch feedbackType {
        case .light:
            lightImpact()
        case .medium:
            mediumImpact()
        case .heavy:
            heavyImpact()
        case .success:
            successImpact()
        case .warning:
            warningImpact()
        case .error:
            errorImpact()
        case .selection:
            interactionImpact()
        case .buttonTap:
            buttonTapImpact()
        case .toggle:
            toggleImpact()
        case .confirmation:
            confirmationImpact()
        case .rejection:
            rejectionImpact()
        }
    }
}

// MARK: - Haptic Feedback Types
extension HapticManager {
    
    /// أنواع الاهتزاز المختلفة
    enum HapticFeedbackType {
        case light          // خفيف
        case medium         // متوسط
        case heavy          // قوي
        case success        // نجاح
        case warning        // تحذير
        case error          // خطأ
        case selection      // تحديد
        case buttonTap      // ضغط زر
        case toggle         // تفعيل/تعطيل
        case confirmation   // تأكيد
        case rejection      // رفض
    }
}

// MARK: - UIButton Extension for Haptic
extension UIButton {
    
    /// إضافة اهتزاز تلقائي عند الضغط على الزر
    func addHapticFeedback(_ feedbackType: HapticManager.HapticFeedbackType = .buttonTap) {
        addTarget(self, action: #selector(handleHapticFeedback), for: .touchDown)
        
        // حفظ نوع الاهتزاز
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.hapticType,
            feedbackType,
            .OBJC_ASSOCIATION_RETAIN
        )
    }
    
    @objc private func handleHapticFeedback() {
        if let feedbackType = objc_getAssociatedObject(self, &AssociatedKeys.hapticType) as? HapticManager.HapticFeedbackType {
            HapticManager.shared.performHaptic(for: feedbackType)
        } else {
            HapticManager.shared.buttonTapImpact()
        }
    }
    
    private struct AssociatedKeys {
        static var hapticType = "hapticType"
    }
}

// MARK: - UIView Extension for Haptic
extension UIView {
    
    /// إضافة اهتزاز عند التفاعل مع العنصر
    func addTapHaptic(_ feedbackType: HapticManager.HapticFeedbackType = .light) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleViewHaptic))
        addGestureRecognizer(tapGesture)
        
        objc_setAssociatedObject(
            self,
            &ViewAssociatedKeys.viewHapticType,
            feedbackType,
            .OBJC_ASSOCIATION_RETAIN
        )
    }
    
    @objc private func handleViewHaptic() {
        if let feedbackType = objc_getAssociatedObject(self, &ViewAssociatedKeys.viewHapticType) as? HapticManager.HapticFeedbackType {
            HapticManager.shared.performHaptic(for: feedbackType)
        }
    }
    
    private struct ViewAssociatedKeys {
        static var viewHapticType = "viewHapticType"
    }
}

// MARK: - Usage Examples
/*
 
 // استخدام بسيط
 HapticManager.shared.lightImpact()
 HapticManager.shared.successImpact()
 
 // استخدام متقدم
 HapticManager.shared.performHaptic(for: .confirmation)
 
 // إضافة اهتزاز للأزرار
 myButton.addHapticFeedback(.medium)
 
 // إضافة اهتزاز للعناصر
 myView.addTapHaptic(.light)
 
 // أنماط معقدة
 HapticManager.shared.complexSuccessPattern()
 
 */
