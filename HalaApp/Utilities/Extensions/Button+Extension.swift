//
//  Button+Extension.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

extension UIButton {
    
    /// إعداد Button مخصص
    func setupCustomButton(title: Buttons,
                           titleColor: AppColors ,
                           backgroundColor: AppColors? = nil,
                           ofSize: Sizes,
                           font: Fonts,
                           fontStyle: FontStyle = .regular,
                           alignment: Directions = .auto,
                           enablePressAnimation: Bool = true
    ) {
        
        self.setTitle(title.titleButton, for: .normal)
        setTitleColor(titleColor.color, for: .normal)

        self.backgroundColor = backgroundColor?.color
        
        
        
        self.titleLabel?.font = FontManager.shared.fontApp(family: font, style: fontStyle, size: ofSize)
        self.titleLabel?.textAlignment = alignment.textAlignment
        self.titleLabel?.adjustsFontForContentSizeCategory = true
    
        // 🎯 تأثير الضغط
            if enablePressAnimation {
                addPressAnimation()
        }
    }
    
    
    // MARK: - Animation Effects
    
    /// إضافة تأثير ضغط للزر
    func addPressAnimation() {
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    /// إزالة تأثير الضغط
    func removePressAnimation() {
        removeTarget(self, action: #selector(buttonPressed), for: .touchDown)
        removeTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    @objc private func buttonPressed() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.9
        }
}
    
    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
        }
    }

    
}
