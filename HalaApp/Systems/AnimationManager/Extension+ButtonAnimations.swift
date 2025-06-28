//
//  Extension+ButtonAnimations.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 28/06/2025.
//

import UIKit

// MARK: - Button Interaction Animations
extension AnimationManager {
    
    /// أنيميشن ضغط الزر (Touch Down)
    public func buttonTouchDown(
        button: UIView,
        scale: CGFloat = 0.95,
        alpha: CGFloat = 0.8,
        config: AnimationConfig = Defaults.quick
    ) {
        UIView.animate(
            withDuration: config.duration,
            delay: config.delay,
            options: config.options,
            animations: {
                button.transform = CGAffineTransform(scaleX: scale, y: scale)
                button.alpha = alpha
            }
        )
    }
    
    /// أنيميشن إفلات الزر (Touch Up)
    public func buttonTouchUp(
        button: UIView,
        config: AnimationConfig = Defaults.quick
    ) {
        UIView.animate(
            withDuration: config.duration,
            delay: config.delay,
            options: config.options,
            animations: {
                button.transform = .identity
                button.alpha = 1.0
            },
            completion: { _ in config.completion?() }
        )
    }
    
    /// أنيميشن نقر الزر الكامل
    public func buttonTap(
        button: UIView,
        hapticFeedback: Bool = true,
        config: AnimationConfig = Defaults.quick,
        completion: (() -> Void)? = nil
    ) {
        if hapticFeedback {
            HapticManager.shared.lightImpact()
        }
        
        buttonTouchDown(button: button, config: config)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
            self.buttonTouchUp(button: button, config: config)
            completion?()
        }
    }
}

// MARK: - Content Update Animations
extension AnimationManager {
    
    /// أنيميشن تحديث المحتوى (مثل OnboardingVC)
    public func updateContent(
        views: [UIView],
        exitConfig: AnimationConfig = AnimationConfig(duration: 0.3),
        enterConfig: AnimationConfig = AnimationConfig(duration: 0.3, delay: 0.1),
        contentUpdate: @escaping () -> Void
    ) {
        // أنيميشن الخروج
        UIView.animate(
            withDuration: exitConfig.duration,
            animations: {
                views.forEach { view in
                    view.alpha = 0
                    view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }
            }
        ) { _ in
            // تحديث المحتوى
            contentUpdate()
            
            // أنيميشن الدخول
            UIView.animate(
                withDuration: enterConfig.duration,
                delay: enterConfig.delay,
                options: .curveEaseOut,
                animations: {
                    views.forEach { view in
                        view.alpha = 1
                        view.transform = .identity
                    }
                },
                completion: { _ in
                    enterConfig.completion?()
                }
            )
        }
    }
    
    /// أنيميشن السهم (للتنقل)
    public func animateArrow(
        arrowView: UIView,
        isRTL: Bool = false,
        config: AnimationConfig = Defaults.spring
    ) {
        UIView.animate(
            withDuration: config.duration,
            delay: config.delay,
            usingSpringWithDamping: config.dampingRatio,
            initialSpringVelocity: config.initialVelocity,
            options: .allowUserInteraction,
            animations: {
                arrowView.transform = arrowView.transform.scaledBy(x: 1.1, y: 1.1)
            }
        ) { _ in
            UIView.animate(
                withDuration: 0.2,
                delay: 0.2,
                options: .allowUserInteraction,
                animations: {
                    let rotationAngle: CGFloat = isRTL ? 0 : .pi
                    arrowView.transform = CGAffineTransform(rotationAngle: rotationAngle)
                },
                completion: { _ in config.completion?() }
            )
        }
    }
}

