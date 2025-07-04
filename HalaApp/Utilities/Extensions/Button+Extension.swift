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
                           enablePressAnimation: Bool = true,
                           responsive: Bool = true  // خيار جديد للتجاوب

    ) {
        
        self.setTitle(title.titleButton, for: .normal)
        setTitleColor(titleColor.color, for: .normal)

        self.backgroundColor = backgroundColor?.color
        
        // اختيار الخط حسب التجاوب
        if responsive {
            self.titleLabel?.font = FontManager.shared.responsiveFont(family: font, style: fontStyle, size: ofSize)
        } else {
            self.titleLabel?.font = FontManager.shared.fontApp(family: font, style: fontStyle, size: ofSize)
        }

        
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

    /// تعيين صورة للزر مع دعم الثيم
    func setImage(_ imageName: AppImage, for state: UIControl.State = .normal, theme: ThemeManager.ThemeMode? = nil) {
        let image = ImageManager.image(imageName, for: theme)
        self.setImage(image, for: state)
    }
    
    /// تعيين صورة مع لون للزر
    func setImage(_ imageName: AppImage, tintColor: AppColors, for state: UIControl.State = .normal) {
        let image = ImageManager.image(imageName, tintColor: tintColor)
        self.setImage(image, for: state)
    }
    
    /// تعيين صورة للزر باستخدام التكوين
       func setImage(configuration: ImageConfiguration, for state: UIControl.State = .normal) {
           let image = configuration.generateImage()
           self.setImage(image, for: state)
       }
       
       /// تعيين أيقونة التنقل للزر
       func setNavigationIcon(_ imageName: AppImage, size: CGFloat = 24, for state: UIControl.State = .normal) {
           setImage(configuration: .navigationIcon(imageName, size: size), for: state)
       }
    
    /// تعيين صورة من Assets للزر مع دعم الثيم
    func setImageFromAssets(_ imageName: String, for state: UIControl.State = .normal, tintColor: AppColors? = nil) {
        if let tintColor = tintColor {
            self.setImage(ImageManager.imageFromAssets(imageName, tintColor: tintColor), for: state)
        } else {
            self.setImage(ImageManager.imageFromAssets(imageName), for: state)
        }
    }
    
    /// تعيين صورة من Assets بحجم محدد
    func setImageFromAssets(_ imageName: String, size: CGSize, for state: UIControl.State = .normal, tintColor: AppColors? = nil) {
        var image = ImageManager.imageFromAssets(imageName, size: size)
        
        if let tintColor = tintColor {
            image = image?.withTintColor(tintColor.color)
        }
        
        self.setImage(image, for: state)
    }


    
}
