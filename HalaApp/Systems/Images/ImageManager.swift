//
//  ImageManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 23/06/2025.
//

import UIKit

class ImageManager {
    
    // MARK: - Singleton
    static let shared = ImageManager()
    private init() {}
    
    // MARK: - Main Methods
    
    /// الحصول على صورة بناءً على الثيم الحالي
    
    /// الحصول على صورة بناءً على الثيم الحالي
    static func image(_ imageName: AppImage, for theme: ThemeManager.ThemeMode? = nil) -> UIImage? {
        let currentTheme = theme ?? ThemeManager.shared.currentTheme
        let isDark = shouldUseDarkImage(fot: currentTheme)
        
        return getImage(imageName, isDark: isDark)
    }
    
    /// الحصول على صورة مع لون مخصص
    static func image(_ imageName: AppImage, tintColor: AppColors) -> UIImage? {
        guard let image = UIImage(named: imageName.imageName) else {
            print("⚠️ الصورة غير موجودة: \(imageName.imageName)")
            return nil
        }
        return image.withTintColor(tintColor.color)
    }
    
    /// الحصول على صورة بحجم محدد
    static func image(_ imageName: AppImage, size: CGSize) -> UIImage? {
        guard let image = UIImage(named: imageName.imageName) else {
            print("⚠️ الصورة غير موجودة: \(imageName.imageName)")
            return nil
        }
        return image.resized(to: size)
    }
    
    /// الحصول على صورة دائرية
    static func circularImage(_ imageName: AppImage, diameter: CGFloat) -> UIImage? {
        guard let image = UIImage(named: imageName.imageName) else {
            print("⚠️ الصورة غير موجودة: \(imageName.imageName)")
            return nil
        }
        return image.circularImage(with: diameter)
    }
    

       /// إنشاء أيقونة بديلة في حالة عدم وجود الأيقونة
       private static func createPlaceholderIcon() -> UIImage? {
           // إنشاء أيقونة بسيطة باستخدام SF Symbols
           let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
           return UIImage(systemName: "circle", withConfiguration: config)
       }

  

    // MARK: - Helper Methods
    private static func shouldUseDarkImage(fot theme: ThemeManager.ThemeMode) -> Bool {
        switch theme {
         case .dark:
             return true
         case .light:
             return false
         case .auto:
             return ThemeManager.shared.isDarkModeActive
         }
    }
    
    /// الحصول على الصورة الفعلية
    private static func getImage(_ imageName: AppImage, isDark: Bool) -> UIImage? {
        // محاولة الحصول على نسخة الثيم أولاً
        let themeImageName = isDark ? "\(imageName.imageName)_dark" : "\(imageName.imageName)_light"
        
        if let themeImage = UIImage(named: themeImageName) {
            print("✅ تم العثور على صورة الثيم: \(themeImageName)")
            return themeImage
        }
        
        // إذا لم توجد نسخة الثيم، استخدم الصورة العادية
        guard let defaultImage = UIImage(named: imageName.imageName) else {
            print("❌ لم يتم العثور على الصورة: \(imageName.imageName)")
            return nil
        }
        
        print("⚠️ استخدام الصورة الافتراضية: \(imageName.imageName)")
        return defaultImage
    }

}

// MARK: - Assets Support Extension
extension ImageManager {
    
    // MARK: - 🎯 دوال للعمل مع أسماء الصور من Assets
    
    /// الحصول على صورة باسمها من Assets مع دعم الثيم
    static func imageFromAssets(_ imageName: String, for theme: ThemeManager.ThemeMode? = nil) -> UIImage? {
        let currentTheme = theme ?? ThemeManager.shared.currentTheme
        let isDark = shouldUseDarkImage(fot: currentTheme)
        
        return getImageFromAssets(imageName, isDark: isDark)
    }
    
    /// الحصول على صورة من Assets مع لون مخصص
    static func imageFromAssets(_ imageName: String, tintColor: AppColors) -> UIImage? {
        guard let image = UIImage(named: imageName) else {
            print("⚠️ الصورة غير موجودة في Assets: \(imageName)")
            return nil
        }
        return image.withTintColor(tintColor.color)
    }
    
    /// الحصول على صورة من Assets بحجم محدد
    static func imageFromAssets(_ imageName: String, size: CGSize) -> UIImage? {
        guard let image = UIImage(named: imageName) else {
            print("⚠️ الصورة غير موجودة في Assets: \(imageName)")
            return nil
        }
        return image.resized(to: size)
    }
    
    /// الحصول على صورة دائرية من Assets
    static func circularImageFromAssets(_ imageName: String, diameter: CGFloat) -> UIImage? {
        guard let image = UIImage(named: imageName) else {
            print("⚠️ الصورة غير موجودة في Assets: \(imageName)")
            return nil
        }
        return image.circularImage(with: diameter)
    }
    
    // MARK: - 🔧 Helper Methods للـ Assets
    
    /// البحث عن صورة في Assets مع دعم الثيم
    private static func getImageFromAssets(_ imageName: String, isDark: Bool) -> UIImage? {
        // محاولة الحصول على نسخة الثيم أولاً
        let themeImageName = isDark ? "\(imageName)_dark" : "\(imageName)_light"
        
        if let themeImage = UIImage(named: themeImageName) {
            print("✅ تم العثور على صورة الثيم من Assets: \(themeImageName)")
            return themeImage
        }
        
        // إذا لم توجد نسخة الثيم، استخدم الصورة العادية
        guard let defaultImage = UIImage(named: imageName) else {
            print("❌ لم يتم العثور على الصورة في Assets: \(imageName)")
            return nil
        }
        
        print("⚠️ استخدام الصورة الافتراضية من Assets: \(imageName)")
        return defaultImage
    }
}



// MARK: - Convenience Extensions

extension ImageManager {
    
    /// اختصارات سريعة للصور الشائعة
    static var backIcon: UIImage? {
        return image(.back)
    }
    
    static var menuIcon: UIImage? {
        return image(.menu)
    }
    
    static var closeIcon: UIImage? {
        return image(.close)
    }
    
    static var searchIcon: UIImage? {
        return image(.search)
    }
    
    static var notificationIcon: UIImage? {
        return image(.notification)
    }
    
    static var saveIcon: UIImage? {
        return image(.save)
    }
    
    static var shareIcon: UIImage? {
        return image(.share)
    }
    
    static var logoImage: UIImage? {
        return image(.logo)
    }
}

// MARK: - Theme Observer
extension ImageManager {
    
    /// بدء مراقبة تغييرات الثيم
    static func startThemeObserver() {
        NotificationCenter.default.addObserver(forName: .themeDidChange,
                                               object: self,
                                               queue: .main) { notification in
            // يمكن إضافة منطق إضافي هنا عند تغيير الثيم
            print("🎨 ImageManager: تم تغيير الثيم")

        }
    }
}

// MARK: - Usage Examples
/*
 
 📱 أمثلة الاستخدام:
 ===================
 
 // 1️⃣ الحصول على صورة حسب الثيم الحالي
 let backImage = ImageManager.image(.back)
 
 // 2️⃣ الحصول على صورة لثيم محدد
 let darkLogo = ImageManager.image(.logo, for: .dark)
 
 // 3️⃣ صورة مع لون مخصص
 let tintedIcon = ImageManager.image(.menu, tintColor: .primary)
 
 // 4️⃣ صورة بحجم محدد
 let smallIcon = ImageManager.image(.notification, size: CGSize(width: 24, height: 24))
 
 // 5️⃣ صورة دائرية
 let circularLogo = ImageManager.circularImage(.logo, diameter: 50)
 
 // 6️⃣ استخدام الاختصارات
 let backIcon = ImageManager.backIcon
 let menuIcon = ImageManager.menuIcon
 
 // 7️⃣ تعيين صورة لـ UIImageView
 imageView.setImage(.logo)
 imageView.setImage(.menu, tintColor: .accent)
 imageView.setCircularImage(.logo, diameter: 60)
 
 // 8️⃣ تعيين صورة لـ UIButton
 button.setImage(.save)
 button.setImage(.close, tintColor: .error)
 
 */

/*
// MARK: - 2️⃣ استخدام أسماء Assets مباشرة (للصور الديناميكية)
// ===========================================================

// 🔹 الطريقة المباشرة
let userPhoto = ImageManager.imageFromAssets("user_avatar")
let darkBanner = ImageManager.imageFromAssets("banner_bg", for: .dark)
let tintedIcon = ImageManager.imageFromAssets("heart_icon", tintColor: .error)
let resizedImage = ImageManager.imageFromAssets("product_photo", size: CGSize(width: 100, height: 100))
let circularAvatar = ImageManager.circularImageFromAssets("profile_pic", diameter: 50)

// 🔹 مع UIImageView - Extensions
avatarImageView.setImageFromAssets("user_photo")                    // صورة بسيطة
backgroundView.setImageFromAssets("login_bg", tintColor: .accent)   // مع لون
thumbnailView.setImageFromAssets("product_thumb", size: CGSize(width: 80, height: 80)) // بحجم محدد
profileView.setCircularImageFromAssets("avatar", diameter: 60)     // دائرية

// 🔹 مع UIButton - Extensions
socialButton.setImageFromAssets("google_icon")                     // صورة بسيطة
loginButton.setImageFromAssets("facebook_icon", tintColor: .primary) // مع لون
headerButton.setImageFromAssets("menu_burger", size: CGSize(width: 24, height: 24)) // بحجم محدد

 */
