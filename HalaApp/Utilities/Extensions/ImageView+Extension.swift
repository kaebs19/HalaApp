//
//  ImageView+Extension.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 23/06/2025.
//

import UIKit

extension UIImageView {
    /// تعيين صورة مع دعم الثيم
    func setImage(_ imageName: AppImage, for theme: ThemeManager.ThemeMode? = nil) {
        self.image = ImageManager.image(imageName, for: theme)
    }
    
    /// تعيين صورة مع لون
    func setImage(_ imageName: AppImage, tintColor: AppColors) {
        self.image = ImageManager.image(imageName, tintColor: tintColor)
    }
    
    /// تعيين صورة بحجم محدد
    func setImage(_ imageName: AppImage, size: CGSize) {
        self.image = ImageManager.image(imageName, size: size)
    }
    
    /// تعيين صورة دائرية
    func setCircularImage(_ imageName: AppImage, diameter: CGFloat) {
        self.image = ImageManager.circularImage(imageName, diameter: diameter)
    }

}

// MARK: - Quick Access Extensions
extension UIImageView {
    
    /// تعيين صورة باستخدام التكوين
    func setImage(configuration: ImageConfiguration) {
        self.image = configuration.generateImage()
    }
    
    /// تعيين أيقونة التنقل
    func setNavigationIcon(_ imageName: AppImage, size: CGFloat = 24) {
        setImage(configuration: .navigationIcon(imageName, size: size))
    }
    
    /// تعيين صورة ملف شخصي
    func setProfileImage(_ imageName: AppImage, diameter: CGFloat = 60) {
        setImage(configuration: .profileImage(imageName, diameter: diameter))
    }
    
    /// تعيين شعار التطبيق
    func setAppLogo(size: CGSize = CGSize(width: 120, height: 120)) {
        setImage(configuration: .appLogo(size: size))
    }
}

// MARK: - 🎨 Extensions للعناصر مع دعم Assets
extension UIImageView {
    
    /// تعيين صورة من Assets باسمها مع دعم الثيم
    func setImageFromAssets(_ imageName: String, tintColor: AppColors? = nil) {
        if let tintColor = tintColor {
            self.image = ImageManager.imageFromAssets(imageName, tintColor: tintColor)
        } else {
            self.image = ImageManager.imageFromAssets(imageName)
        }
    }
    
    /// تعيين صورة دائرية من Assets
    func setCircularImageFromAssets(_ imageName: String, diameter: CGFloat) {
        self.image = ImageManager.circularImageFromAssets(imageName, diameter: diameter)
    }
    
    /// تعيين صورة من Assets بحجم محدد
    func setImageFromAssets(_ imageName: String, size: CGSize, tintColor: AppColors? = nil) {
        var image = ImageManager.imageFromAssets(imageName, size: size)
        
        if let tintColor = tintColor {
            image = image?.withTintColor(tintColor.color)
        }
        
        self.image = image
    }
}
