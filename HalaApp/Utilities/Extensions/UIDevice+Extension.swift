//
//  UIDevice+Extension.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 24/06/2025.
//

import UIKit


// MARK: - Device Type Extension
extension UIDevice {
    
    /// تحديد نوع الجهاز
    enum DeviceType {
        case iPhone_SE      // 320-375 width
        case iPhone_Standard // 375-390 width
        case iPhone_Plus    // 414-428 width
        case iPad           // 768+ width
        case iPad_Pro       // 1024+ width
    }
    
    /// الحصول على نوع الجهاز الحالي
    static var deviceType: DeviceType {
        let width = UIScreen.main.bounds.width
        
        switch width {
        case 0..<375:
            return .iPhone_SE
        case 375..<414:
            return .iPhone_Standard
        case 414..<768:
            return .iPhone_Plus
        case 768..<1024:
            return .iPad
        default:
            return .iPad_Pro
        }
    }
    
    /// التحقق من كون الجهاز iPad
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// التحقق من كون الجهاز iPhone
    static var isIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

// MARK: - Responsive Sizing Extension
extension CGFloat {
    
    /// تحويل القيمة لتكون متجاوبة حسب عرض الشاشة
    /// - Parameter basedOnWidth: العرض المرجعي (افتراضي: 375 للـ iPhone)
    /// - Returns: القيمة المتجاوبة
    func responsive(basedOnWidth: CGFloat = 375) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (self * screenWidth) / basedOnWidth
    }
    
    /// تحويل القيمة لتكون متجاوبة حسب ارتفاع الشاشة
    /// - Parameter basedOnHeight: الارتفاع المرجعي (افتراضي: 812 للـ iPhone)
    /// - Returns: القيمة المتجاوبة
    func responsiveHeight(basedOnHeight: CGFloat = 812) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return (self * screenHeight) / basedOnHeight
    }
    
    /// الحصول على قيمة مختلفة حسب نوع الجهاز
    /// - Parameters:
    ///   - iPhone: القيمة للـ iPhone
    ///   - iPad: القيمة للـ iPad
    /// - Returns: القيمة المناسبة للجهاز
    static func deviceSpecific(iPhone: CGFloat, iPad: CGFloat) -> CGFloat {
        return UIDevice.isIPad ? iPad : iPhone
    }
}

// MARK: - UIView Responsive Extension
extension UIView {
    
    /// إضافة constraints متجاوبة للزر
    /// - Parameters:
    ///   - leadingTrailing: المسافة من اليمين واليسار
    ///   - height: الارتفاع (اختياري)
    ///   - heightMultiplier: مضاعف الارتفاع بالنسبة للـ Safe Area
    ///   - bottomSafeArea: المسافة من أسفل الـ Safe Area
    func makeResponsiveButton(
        leadingTrailing: CGFloat = 24,
        height: CGFloat? = nil,
        heightMultiplier: CGFloat = 0.068,
        bottomSafeArea: CGFloat = 50
    ) {
        guard let superview = self.superview else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Leading & Trailing constraints
        let leadingSpacing = leadingTrailing.responsive()
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(greaterThanOrEqualTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: leadingSpacing),
            self.trailingAnchor.constraint(lessThanOrEqualTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -leadingSpacing),
            self.centerXAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        // Height constraint
        if let height = height {
            let responsiveHeight = height.responsive()
            self.heightAnchor.constraint(equalToConstant: responsiveHeight).isActive = true
        } else {
            // Use multiplier for responsive height
            self.heightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.heightAnchor, multiplier: heightMultiplier).isActive = true
        }
        
        // Bottom constraint
        let bottomSpacing = bottomSafeArea.responsive()
        self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -bottomSpacing).isActive = true
        
        // Maximum width for iPad
        if UIDevice.isIPad {
            self.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        }
    }
    
    /// إضافة constraints للـ TextField بشكل متجاوب
    /// - Parameters:
    ///   - leadingTrailing: المسافة من اليمين واليسار
    ///   - height: الارتفاع
    ///   - topElement: العنصر العلوي للربط معه
    ///   - spacing: المسافة من العنصر العلوي
    func makeResponsiveTextField(
        leadingTrailing: CGFloat = 24,
        height: CGFloat = 50,
        topElement: UIView? = nil,
        spacing: CGFloat = 16
    ) {
        guard let superview = self.superview else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingSpacing = leadingTrailing.responsive()
        let fieldHeight = height.responsive()
        let topSpacing = spacing.responsive()
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: leadingSpacing),
            self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -leadingSpacing),
            self.heightAnchor.constraint(equalToConstant: fieldHeight)
        ])
        
        if let topElement = topElement {
            self.topAnchor.constraint(equalTo: topElement.bottomAnchor, constant: topSpacing).isActive = true
        }
    }
    
    /// جعل corner radius متجاوب
    /// - Parameter radius: نصف القطر الأساسي
    func setResponsiveCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius.responsive()
    }
    
    /// جعل الـ shadow متجاوب
    /// - Parameters:
    ///   - offset: الإزاحة
    ///   - radius: نصف القطر
    ///   - opacity: الشفافية
    func setResponsiveShadow(offset: CGSize, radius: CGFloat, opacity: Float = 0.3) {
        self.layer.shadowOffset = CGSize(width: offset.width.responsive(),
                                        height: offset.height.responsive())
        self.layer.shadowRadius = radius.responsive()
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = UIColor.black.cgColor
    }
}

// MARK: - UIFont Responsive Extension
extension UIFont {
    
    /// إنشاء font متجاوب حسب حجم الشاشة
    /// - Parameters:
    ///   - size: الحجم الأساسي
    ///   - weight: وزن الخط
    ///   - style: نمط الخط (اختياري)
    /// - Returns: الخط المتجاوب
    static func responsiveFont(size: CGFloat, weight: UIFont.Weight = .regular, style: UIFont.TextStyle? = nil) -> UIFont {
        let responsiveSize = size.responsive()
        
        if let style = style {
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
            return UIFont.systemFont(ofSize: responsiveSize, weight: weight)
        } else {
            return UIFont.systemFont(ofSize: responsiveSize, weight: weight)
        }
    }
    
    /// أحجام خطوط مقترحة للعناصر المختلفة
    static var responsiveLargeTitle: UIFont {
        return responsiveFont(size: .deviceSpecific(iPhone: 28, iPad: 22), weight: .bold)
    }
    
    static var responsiveTitle: UIFont {
        return responsiveFont(size: .deviceSpecific(iPhone: 20, iPad: 17), weight: .semibold)
    }
    
    static var responsiveBody: UIFont {
        return responsiveFont(size: .deviceSpecific(iPhone: 16, iPad: 14), weight: .regular)
    }
    
    static var responsiveCaption: UIFont {
        return responsiveFont(size: .deviceSpecific(iPhone: 12, iPad: 14), weight: .regular)
    }
}
