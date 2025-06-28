//
//  ImageConfiguration.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 23/06/2025.
//

import UIKit

// MARK: - Image Configuration

struct ImageConfiguration {
    let imageName: Images
    let size: CGSize?
    let tintColor: AppColors?
    let isCircular: Bool
    let circularDiameter: CGFloat?
    let theme: ThemeManager.ThemeMode?
    
    // MARK: - Initializers
    init(
        _ imageName: Images,
        size: CGSize? = nil,
        tintColor: AppColors? = nil,
        isCircular: Bool = false,
        circularDiameter: CGFloat? = nil,
        theme: ThemeManager.ThemeMode? = nil
    ) {
        self.imageName = imageName
        self.size = size
        self.tintColor = tintColor
        self.isCircular = isCircular
        self.circularDiameter = circularDiameter
        self.theme = theme
    }
    
    // MARK: - Generate Image
    func generateImage() -> UIImage? {
        var finalImage: UIImage?
        
        // 1. الحصول على الصورة الأساسية
        finalImage = ImageManager.image(imageName, for: theme)
        
        // 2. تطبيق تغيير الحجم
        if let size = size, let image = finalImage {
            finalImage = image.resized(to: size)
        }
        
        // 3. تطبيق اللون
        if let tintColor = tintColor, let image = finalImage {
            finalImage = image.withTintColor(tintColor.color)
        }
        
        // 4. تطبيق الشكل الدائري
        if isCircular, let diameter = circularDiameter, let image = finalImage {
            finalImage = image.circularImage(with: diameter)
        }
        
        return finalImage
    }
}


// MARK: - Predefined Configurations
extension ImageConfiguration {
    
    // MARK: - Navigation Icons
    static func navigationIcon(_ imageName: Images, size: CGFloat = 24) -> ImageConfiguration {
        return ImageConfiguration(
            imageName,
            size: CGSize(width: size, height: size),
            tintColor: .primary
        )
    }
    
    static func backButton(size: CGFloat = 24) -> ImageConfiguration {
        return navigationIcon(.back, size: size)
    }
    
    static func menuButton(size: CGFloat = 24) -> ImageConfiguration {
        return navigationIcon(.menu, size: size)
    }
    
    static func closeButton(size: CGFloat = 24) -> ImageConfiguration {
        return navigationIcon(.close, size: size)
    }
    
    // MARK: - Tab Bar Icons
    static func tabBarIcon(_ imageName: Images) -> ImageConfiguration {
        return ImageConfiguration(
            imageName,
            size: CGSize(width: 28, height: 28),
            tintColor: .primary
        )
    }
    
    // MARK: - Profile Images
    static func profileImage(_ imageName: Images, diameter: CGFloat = 60) -> ImageConfiguration {
        return ImageConfiguration(
            imageName,
            isCircular: true,
            circularDiameter: diameter
        )
    }
    
    // MARK: - Logo Configurations
    static func appLogo(size: CGSize = CGSize(width: 120, height: 120)) -> ImageConfiguration {
        return ImageConfiguration(.logo, size: size)
    }
    
    static func smallLogo(size: CGFloat = 40) -> ImageConfiguration {
        return ImageConfiguration(
            .logo,
            size: CGSize(width: size, height: size)
        )
    }
    
    // MARK: - Social Media Icons
    static func socialIcon(_ imageName: Images, size: CGFloat = 32) -> ImageConfiguration {
        return ImageConfiguration(
            imageName,
            size: CGSize(width: size, height: size)
        )
    }
    
    static func googleIcon(size: CGFloat = 32) -> ImageConfiguration {
        return socialIcon(.google, size: size)
    }
    
    static func appleIcon(size: CGFloat = 32) -> ImageConfiguration {
        return socialIcon(.apple, size: size)
    }

}
