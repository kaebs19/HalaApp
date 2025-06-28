//
//  UIViewController+Animation.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 28/06/2025.
//

import UIKit

// MARK: - UIViewController Animation Extensions
extension UIViewController {
    
    // MARK: - Content Update Animations
    
    /// تحديث المحتوى مع أنيميشن (مثل OnboardingVC)
    func updateContentAnimated(
        views: [UIView],
        exitDuration: TimeInterval = 0.3,
        enterDuration: TimeInterval = 0.3,
        enterDelay: TimeInterval = 0.1,
        contentUpdate: @escaping () -> Void,
        completion: (() -> Void)? = nil
    ) {
        let exitConfig = AnimationConfig(duration: exitDuration)
        let enterConfig = AnimationConfig(
            duration: enterDuration,
            delay: enterDelay,
            completion: completion
        )
        
        AnimationManager.shared.updateContent(
            views: views,
            exitConfig: exitConfig,
            enterConfig: enterConfig,
            contentUpdate: contentUpdate
        )
    }
    
    /// أنيميشن السهم للتنقل
    func animateNavigationArrow(
        arrowView: UIView,
        completion: (() -> Void)? = nil
    ) {
        let isRTL = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
        let config = AnimationConfig(completion: completion)
        
        AnimationManager.shared.animateArrow(
            arrowView: arrowView,
            isRTL: isRTL,
            config: config
        )
    }
    
    // MARK: - Button Setup with Animations
    
    /// إعداد زر تفاعلي مع أنيميشنز
    func setupInteractiveButton(
        _ button: UIButton,
        touchDownAction: Selector? = nil,
        touchUpAction: Selector? = nil,
        tapAction: Selector,
        hapticFeedback: Bool = true
    ) {
        // إضافة أحداث اللمس
        if let touchDown = touchDownAction {
            button.addTarget(self, action: touchDown, for: .touchDown)
        } else {
            button.addTarget(self, action: #selector(defaultButtonTouchDown(_:)), for: .touchDown)
        }
        
        if let touchUp = touchUpAction {
            button.addTarget(self, action: touchUp, for: [.touchUpInside, .touchUpOutside, .touchCancel])
        } else {
            button.addTarget(self, action: #selector(defaultButtonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        }
        
        button.addTarget(self, action: tapAction, for: .touchUpInside)
        
        // حفظ معلومات الهابتك
        button.accessibilityHint = hapticFeedback ? "haptic_enabled" : "haptic_disabled"
    }
    
    /// إعداد زر بأنيميشن تلقائي للضغط
    @objc private func defaultButtonTouchDown(_ sender: UIButton) {
        let hapticEnabled = sender.accessibilityHint == "haptic_enabled"
        if hapticEnabled {
            HapticManager.shared.lightImpact()
        }
        sender.buttonTouchDown()
    }
    
    /// إعداد زر بأنيميشن تلقائي للإفلات
    @objc private func defaultButtonTouchUp(_ sender: UIButton) {
        sender.buttonTouchUp()
    }
    
    // MARK: - Field Validation Animations
    
    /// التحقق من صحة الحقول مع أنيميشن
    func validateFields(
        _ validations: [(view: UIView, isValid: Bool)],
        showSuccess: Bool = true
    ) -> Bool {
        var allValid = true
        
        for validation in validations {
            if validation.isValid {
                if showSuccess {
                    validation.view.showValidField()
                } else {
                    validation.view.clearFieldValidation()
                }
            } else {
                validation.view.showInvalidField()
                allValid = false
            }
        }
        
        return allValid
    }
    
    /// مسح جميع أخطاء التحقق
    func clearAllValidationErrors(_ views: [UIView]) {
        views.forEach { $0.clearFieldValidation() }
    }
    
    // MARK: - Screen Transition Animations
    
    /// أنيميشن دخول الشاشة
    func animateScreenEntry(
        views: [UIView],
        delay: TimeInterval = 0.1,
        completion: (() -> Void)? = nil
    ) {
        AnimationManager.shared.cascade(
            views: views,
            type: .fadeIn,
            delay: delay,
            config: AnimationConfig(completion: completion)
        )
    }
    
    /// أنيميشن خروج الشاشة
    func animateScreenExit(
        views: [UIView],
        completion: (() -> Void)? = nil
    ) {
        AnimationManager.shared.parallel(
            views: views,
            type: .fadeOut,
            config: AnimationConfig(duration: 0.2, completion: completion)
        )
    }
    
    // MARK: - Loading State Animations
    
    /// إظهار حالة التحميل مع أنيميشن
    func showLoadingState(
        button: UIButton,
        originalTitle: String? = nil,
        loadingTitle: String = "جاري التحميل..."
    ) {
        button.isEnabled = false
        button.setTitle(loadingTitle, for: .normal)
        button.pulseAnimation()
        
        // حفظ العنوان الأصلي
        if let title = originalTitle {
            button.accessibilityLabel = title
        }
    }
    
    /// إخفاء حالة التحميل
    func hideLoadingState(
        button: UIButton,
        completion: (() -> Void)? = nil
    ) {
        button.isEnabled = true
        
        // استرجاع العنوان الأصلي
        if let originalTitle = button.accessibilityLabel {
            button.setTitle(originalTitle, for: .normal)
            button.accessibilityLabel = nil
        }
        
        button.layer.removeAllAnimations()
        completion?()
    }
    
    // MARK: - Success/Error Animations
    
    /// أنيميشن نجاح العملية
    func showSuccessAnimation(
        view: UIView,
        message: String? = nil,
        completion: (() -> Void)? = nil
    ) {
        HapticManager.shared.successImpact()
        
        view.bounceAnimation {
            if let message = message {
                // يمكن إضافة عرض رسالة هنا
                print("✅ نجح: \(message)")
            }
            completion?()
        }
    }
    
    /// أنيميشن فشل العملية
    func showErrorAnimation(
        view: UIView,
        message: String? = nil,
        completion: (() -> Void)? = nil
    ) {
        HapticManager.shared.errorImpact()
        
        view.shakeAnimation {
            if let message = message {
                // يمكن إضافة عرض رسالة هنا
                print("❌ خطأ: \(message)")
            }
            completion?()
        }
    }
    
    // MARK: - Keyboard Animations
    
    /// أنيميشن ظهور لوحة المفاتيح
    func animateForKeyboardShow(
        scrollView: UIScrollView?,
        contentOffset: CGPoint,
        duration: TimeInterval = 0.3
    ) {
        UIView.animate(withDuration: duration) {
            scrollView?.contentOffset = contentOffset
        }
    }
    
    /// أنيميشن إخفاء لوحة المفاتيح
    func animateForKeyboardHide(
        scrollView: UIScrollView?,
        duration: TimeInterval = 0.3
    ) {
        UIView.animate(withDuration: duration) {
            scrollView?.contentOffset = .zero
        }
    }
    
    // MARK: - Theme Change Animations
    
    /// أنيميشن تغيير النمط (فاتح/داكن)
    func animateThemeChange(
        views: [UIView],
        themeUpdate: @escaping () -> Void,
        completion: (() -> Void)? = nil
    ) {
        // أنيميشن فلاش خفيف أثناء التغيير
        UIView.animate(withDuration: 0.1) {
            views.forEach { $0.alpha = 0.8 }
        } completion: { _ in
            themeUpdate()
            
            UIView.animate(withDuration: 0.2) {
                views.forEach { $0.alpha = 1.0 }
            } completion: { _ in
                completion?()
            }
        }
    }
}


// MARK: - Collection Extensions
extension Array where Element: UIView {
    
    /// أنيميشن متتالي للمجموعة
    func cascadeAnimation(
        type: AnimationType,
        delay: TimeInterval = 0.1,
        duration: TimeInterval = 0.3,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.cascade(
            views: self,
            type: type,
            delay: delay,
            config: config
        )
    }
    
    /// أنيميشن متوازي للمجموعة
    func parallelAnimation(
        type: AnimationType,
        duration: TimeInterval = 0.3,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.parallel(
            views: self,
            type: type,
            config: config
        )
    }
    
    /// إخفاء جميع العناصر مع أنيميشن
    func hideAllAnimated(
        duration: TimeInterval = 0.3,
        completion: (() -> Void)? = nil
    ) {
        parallelAnimation(type: .fadeOut, duration: duration) {
            self.forEach { $0.isHidden = true }
            completion?()
        }
    }
    
    /// إظهار جميع العناصر مع أنيميشن
    func showAllAnimated(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0.1,
        completion: (() -> Void)? = nil
    ) {
        self.forEach { $0.isHidden = false; $0.alpha = 0 }
        cascadeAnimation(type: .fadeIn, delay: delay, duration: duration, completion: completion)
    }
}
/*
🚀 الاستخدام الأساسي
1. الأنيميشنز البسيطة
swift// أنيميشن الظهور التدريجي
myView.fadeIn(duration: 0.5)

// أنيميشن الاختفاء
myView.fadeOut(duration: 0.3)

// أنيميشن التحجيم
myView.scaleAnimation(from: 0.8, to: 1.0)

// أنيميشن الارتداد
myView.bounceAnimation()

// أنيميشن الاهتزاز
myView.shakeAnimation()
2. أنيميشنز الأزرار
swift// إعداد زر تفاعلي (في viewDidLoad)
setupInteractiveButton(
    loginButton,
    tapAction: #selector(loginTapped),
    hapticFeedback: true
)

// أنيميشن ضغط مخصص
@objc private func buttonTouchDown() {
    loginButton.buttonTouchDown(scale: 0.95, alpha: 0.8)
}

@objc private func buttonTouchUp() {
    loginButton.buttonTouchUp()
}

*/
