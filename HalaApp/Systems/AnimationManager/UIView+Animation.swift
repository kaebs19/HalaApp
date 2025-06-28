//
//  UIView+Animation.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 28/06/2025.
//

import Foundation
import UIKit

// MARK: - UIView Animation Extensions
extension UIView {
    
    // MARK: - Basic Animations
    
    /// تطبيق أنيميشن مباشر على UIView
    func animate(
        _ type: AnimationType,
        config: AnimationConfig = AnimationManager.Defaults.normal
    ) {
        AnimationManager.shared.animate(view: self, type: type, config: config)
    }
    
    /// أنيميشن الظهور التدريجي
    func fadeIn(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, delay: delay, completion: completion)
        AnimationManager.shared.animate(view: self, type: .fadeIn, config: config)
    }
    
    /// أنيميشن الاختفاء التدريجي
    func fadeOut(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, delay: delay, completion: completion)
        AnimationManager.shared.animate(view: self, type: .fadeOut, config: config)
    }
    
    /// أنيميشن التحجيم
    func scaleAnimation(
        from: CGFloat = 0.8,
        to: CGFloat = 1.0,
        duration: TimeInterval = 0.3,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.animate(view: self, type: .scale(from: from, to: to), config: config)
    }
    
    /// أنيميشن الارتداد
    func bounceAnimation(
        duration: TimeInterval = 0.8,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.animate(view: self, type: .bounce, config: config)
    }
    
    /// أنيميشن الاهتزاز
    func shakeAnimation(
        duration: TimeInterval = 0.6,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.animate(view: self, type: .shake, config: config)
    }
    
    /// أنيميشن النبض
    func pulseAnimation(
        duration: TimeInterval = 1.0,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.animate(view: self, type: .pulse, config: config)
    }
    
    /// أنيميشن الدوران
    func rotateAnimation(
        angle: CGFloat,
        duration: TimeInterval = 0.3,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.animate(view: self, type: .rotate(angle: angle), config: config)
    }
    
    // MARK: - Slide Animations
    
    /// أنيميشن الانزلاق للداخل
    func slideIn(
        from direction: SlideDirection,
        duration: TimeInterval = 0.5,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.animate(view: self, type: .slideIn(direction: direction), config: config)
    }
    
    /// أنيميشن الانزلاق للخارج
    func slideOut(
        to direction: SlideDirection,
        duration: TimeInterval = 0.5,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.animate(view: self, type: .slideOut(direction: direction), config: config)
    }
    
    // MARK: - Button Animations
    
    /// أنيميشن ضغط الزر
    func buttonTouchDown(
        scale: CGFloat = 0.95,
        alpha: CGFloat = 0.8,
        duration: TimeInterval = 0.1
    ) {
        let config = AnimationConfig(duration: duration)
        AnimationManager.shared.buttonTouchDown(
            button: self,
            scale: scale,
            alpha: alpha,
            config: config
        )
    }
    
    /// أنيميشن إفلات الزر
    func buttonTouchUp(
        duration: TimeInterval = 0.1,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.buttonTouchUp(button: self, config: config)
    }
    
    /// أنيميشن نقر الزر الكامل
    func buttonTapAnimation(
        hapticFeedback: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        AnimationManager.shared.buttonTap(
            button: self,
            hapticFeedback: hapticFeedback,
            completion: completion
        )
    }
    
    // MARK: - Validation Animations
    
    /// أنيميشن حقل غير صحيح
    func showInvalidField(
        borderColor: UIColor = .systemRed,
        borderWidth: CGFloat = 1.0
    ) {
        AnimationManager.shared.invalidField(
            fieldContainer: self,
            borderColor: borderColor,
            borderWidth: borderWidth
        )
    }
    
    /// أنيميشن حقل صحيح
    func showValidField(
        borderColor: UIColor = .systemGreen,
        borderWidth: CGFloat = 1.0
    ) {
        AnimationManager.shared.validField(
            fieldContainer: self,
            borderColor: borderColor,
            borderWidth: borderWidth
        )
    }
    
    /// إزالة حدود التحقق
    func clearFieldValidation() {
        AnimationManager.shared.clearFieldValidation(fieldContainer: self)
    }
    
    // MARK: - Complex Animations
    
    /// أنيميشن الريبل (التموج)
    func rippleAnimation(
        duration: TimeInterval = 0.6,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.animate(view: self, type: .ripple, config: config)
    }
    
    /// أنيميشن الفلاش (الوميض)
    func flashAnimation(
        duration: TimeInterval = 0.3,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.animate(view: self, type: .flash, config: config)
    }
    
    /// أنيميشن الهز (wobble)
    func wobbleAnimation(
        duration: TimeInterval = 0.6,
        completion: (() -> Void)? = nil
    ) {
        let config = AnimationConfig(duration: duration, completion: completion)
        AnimationManager.shared.animate(view: self, type: .wobble, config: config)
    }
    
    // MARK: - Visibility Animations
    
    /// إخفاء مع أنيميشن
    func hideAnimated(
        duration: TimeInterval = 0.3,
        completion: (() -> Void)? = nil
    ) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0
        } completion: { _ in
            self.isHidden = true
            completion?()
        }
    }
    
    /// إظهار مع أنيميشن
    func showAnimated(
        duration: TimeInterval = 0.3,
        completion: (() -> Void)? = nil
    ) {
        self.alpha = 0
        self.isHidden = false
        
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        } completion: { _ in
            completion?()
        }
    }
    
    /// تبديل الرؤية مع أنيميشن
    func toggleVisibilityAnimated(
        duration: TimeInterval = 0.3,
        completion: (() -> Void)? = nil
    ) {
        if isHidden {
            showAnimated(duration: duration, completion: completion)
        } else {
            hideAnimated(duration: duration, completion: completion)
        }
    }

}
