//
//  ValidationAnimations.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 28/06/2025.
//

import UIKit


// MARK: - Validation Animations
extension AnimationManager {
    
    /// أنيميشن حقل غير صحيح (حدود حمراء)
    public func invalidField(
        fieldContainer: UIView,
        borderColor: UIColor = .systemRed,
        borderWidth: CGFloat = 1.0,
        config: AnimationConfig = Defaults.quick
    ) {
        UIView.animate(
            withDuration: config.duration,
            animations: {
                fieldContainer.layer.borderColor = borderColor.cgColor
                fieldContainer.layer.borderWidth = borderWidth
            }
        )
    }
    
    /// أنيميشن حقل صحيح (حدود خضراء)
    public func validField(
        fieldContainer: UIView,
        borderColor: UIColor = .systemGreen,
        borderWidth: CGFloat = 1.0,
        config: AnimationConfig = Defaults.quick
    ) {
        UIView.animate(
            withDuration: config.duration,
            animations: {
                fieldContainer.layer.borderColor = borderColor.cgColor
                fieldContainer.layer.borderWidth = borderWidth
            }
        )
    }
    
    /// إزالة حدود التحقق
    public func clearFieldValidation(
        fieldContainer: UIView,
        config: AnimationConfig = Defaults.quick
    ) {
        UIView.animate(
            withDuration: config.duration,
            animations: {
                fieldContainer.layer.borderWidth = 0
            }
        )
    }
}
