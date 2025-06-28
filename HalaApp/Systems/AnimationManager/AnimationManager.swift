//
//  AnimationManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 28/06/2025.
//

import UIKit


class AnimationManager {
    
    // MARK: - Singleton

   public static let shared = AnimationManager()
    private init() {}
    
    // MARK: - Default Configurations
    public struct Defaults {
        public static let quick = AnimationConfig(duration: 0.1)
        public static let normal = AnimationConfig(duration: 0.3)
        public static let slow = AnimationConfig(duration: 0.6)
        public static let spring = AnimationConfig(
            duration: 0.6,
            dampingRatio: 0.7,
            initialVelocity: 0.5
        )
        public static let bounce = AnimationConfig(
            duration: 0.8,
            dampingRatio: 0.4,
            initialVelocity: 1.0
        )
    }
    
    /// تطبيق أنيميشن على view
    public func animate(
        view: UIView,
        type: AnimationType,
        config: AnimationConfig = Defaults.normal
    ) {
        switch type {
            case .fadeIn:
                fadeIn(view: view, config: config)
            case .fadeOut:
                fadeOut(view: view, config: config)
            case .slideIn(let direction):
                slideIn(view: view, direction: direction, config: config)
            case .slideOut(let direction):
                slideOut(view: view, direction: direction, config: config)
            case .scale(let from, let to):
                scale(view: view, from: from, to: to, config: config)
            case .bounce:
                bounce(view: view, config: config)
            case .shake:
                shake(view: view, config: config)
            case .pulse:
                pulse(view: view, config: config)
            case .flip(let axis):
                flip(view: view, axis: axis, config: config)
            case .rotate(let angle):
                rotate(view: view, angle: angle, config: config)
            case .spring:
                spring(view: view, config: config)
            case .wobble:
                wobble(view: view, config: config)
            case .flash:
                flash(view: view, config: config)
            case .ripple:
                ripple(view: view, config: config)
        }
        
    }
    
    // MARK: - Fade Animations
    private func fadeIn(view: UIView, config: AnimationConfig) {
        view.alpha = 0
        UIView.animate(
            withDuration: config.duration,
            delay: config.delay,
            options: config.options,
            animations: {
                view.alpha = 1
            },
            completion: { _ in config.completion?() }
        )
    }

    private func fadeOut(view: UIView, config: AnimationConfig) {
        UIView.animate(
            withDuration: config.duration,
            delay: config.delay,
            options: config.options,
            animations: {
                view.alpha = 0
            },
            completion: { _ in config.completion?() }
        )
    }

    // MARK: - Slide Animations
    
    private func slideIn(view: UIView, direction: SlideDirection, config: AnimationConfig) {
        let originalTransform = view.transform
        
        // تحديد الاتجاه الأولي
        switch direction {
        case .left:
            view.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
        case .right:
            view.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        case .up:
            view.transform = CGAffineTransform(translationX: 0, y: -view.frame.height)
        case .down:
            view.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        }
        
        UIView.animate(
            withDuration: config.duration,
            delay: config.delay,
            usingSpringWithDamping: config.dampingRatio,
            initialSpringVelocity: config.initialVelocity,
            options: config.options,
            animations: {
                view.transform = originalTransform
            },
            completion: { _ in config.completion?() }
        )
    }
    
    private func slideOut(view: UIView, direction: SlideDirection, config: AnimationConfig) {
        UIView.animate(
            withDuration: config.duration,
            delay: config.delay,
            options: config.options,
            animations: {
                switch direction {
                case .left:
                    view.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
                case .right:
                    view.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
                case .up:
                    view.transform = CGAffineTransform(translationX: 0, y: -view.frame.height)
                case .down:
                    view.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
                }
            },
            completion: { _ in config.completion?() }
        )
    }
    
    // MARK: - Scale Animations
    
    private func scale(view: UIView, from: CGFloat, to: CGFloat, config: AnimationConfig) {
        view.transform = CGAffineTransform(scaleX: from, y: from)
        
        UIView.animate(
            withDuration: config.duration,
            delay: config.delay,
            usingSpringWithDamping: config.dampingRatio,
            initialSpringVelocity: config.initialVelocity,
            options: config.options,
            animations: {
                view.transform = CGAffineTransform(scaleX: to, y: to)
            },
            completion: { _ in config.completion?() }
        )
    }
    
    // MARK: - Complex Animations
    
    private func bounce(view: UIView, config: AnimationConfig) {
        UIView.animate(
            withDuration: config.duration,
            delay: config.delay,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 1.0,
            options: config.options,
            animations: {
                view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
        ) { _ in
            UIView.animate(
                withDuration: config.duration * 0.5,
                animations: {
                    view.transform = .identity
                },
                completion: { _ in config.completion?() }
            )
        }
    }
    
    private func shake(view: UIView, config: AnimationConfig) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = config.duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(config.completion)
        view.layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
    
    private func pulse(view: UIView, config: AnimationConfig) {
        UIView.animate(
            withDuration: config.duration,
            delay: config.delay,
            options: [.repeat, .autoreverse, .allowUserInteraction],
            animations: {
                view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            },
            completion: { _ in
                view.transform = .identity
                config.completion?()
            }
        )
    }
    
    private func flip(view: UIView, axis: FlipAxis, config: AnimationConfig) {
        let rotationKey = axis == .horizontal ? "transform.rotation.y" : "transform.rotation.x"
        
        UIView.animate(
            withDuration: config.duration / 2,
            animations: {
                view.layer.setValue(CGFloat.pi / 2, forKeyPath: rotationKey)
            }
        ) { _ in
            UIView.animate(
                withDuration: config.duration / 2,
                animations: {
                    view.layer.setValue(0, forKeyPath: rotationKey)
                },
                completion: { _ in config.completion?() }
            )
        }
    }
    
    private func rotate(view: UIView, angle: CGFloat, config: AnimationConfig) {
        UIView.animate(
            withDuration: config.duration,
            delay: config.delay,
            options: config.options,
            animations: {
                view.transform = CGAffineTransform(rotationAngle: angle)
            },
            completion: { _ in config.completion?() }
        )
    }
    
    private func spring(view: UIView, config: AnimationConfig) {
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(
            withDuration: config.duration,
            delay: config.delay,
            usingSpringWithDamping: config.dampingRatio,
            initialSpringVelocity: config.initialVelocity,
            options: config.options,
            animations: {
                view.transform = .identity
            },
            completion: { _ in config.completion?() }
        )
    }
    
    private func wobble(view: UIView, config: AnimationConfig) {
        let wobbleAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        wobbleAnimation.values = [0, 0.1, -0.1, 0.05, -0.05, 0]
        wobbleAnimation.duration = config.duration
        wobbleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(config.completion)
        view.layer.add(wobbleAnimation, forKey: "wobble")
        CATransaction.commit()
    }
    
    private func flash(view: UIView, config: AnimationConfig) {
        let originalAlpha = view.alpha
        
        UIView.animate(
            withDuration: config.duration / 2,
            animations: {
                view.alpha = 0.3
            }
        ) { _ in
            UIView.animate(
                withDuration: config.duration / 2,
                animations: {
                    view.alpha = originalAlpha
                },
                completion: { _ in config.completion?() }
            )
        }
    }
    
    private func ripple(view: UIView, config: AnimationConfig) {
        let rippleLayer = CAShapeLayer()
        rippleLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 0, height: 0)).cgPath
        rippleLayer.fillColor = UIColor.clear.cgColor
        rippleLayer.strokeColor = UIColor.systemBlue.cgColor
        rippleLayer.lineWidth = 2
        rippleLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        
        view.layer.addSublayer(rippleLayer)
        
        let animation = CABasicAnimation(keyPath: "path")
        let finalSize = max(view.bounds.width, view.bounds.height) * 2
        let finalPath = UIBezierPath(ovalIn: CGRect(
            x: -finalSize/2,
            y: -finalSize/2,
            width: finalSize,
            height: finalSize
        )).cgPath
        
        animation.toValue = finalPath
        animation.duration = config.duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 1.0
        alphaAnimation.toValue = 0.0
        alphaAnimation.duration = config.duration
        
        rippleLayer.add(animation, forKey: "ripple")
        rippleLayer.add(alphaAnimation, forKey: "alpha")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
            rippleLayer.removeFromSuperlayer()
            config.completion?()
        }
    }


}
