//
//  FontManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 06/06/2025.
//

import Foundation
import UIKit

/// فئة مدير الخطوط

class FontManager {
    
    static let shared = FontManager()
    
    private init() {}
    
    /// دالة الحصول على الخط المطلوب
    func fontApp(family: Fonts , style: FontStyle , size: Sizes) -> UIFont {
        
        let fontName = "\(family.name)-\(style.rawValue)"
        
        // في حالة وُجد الخط المطلوب يتم استخدامه، وإلا يتم استخدام الخط الافتراضي
        
        if let font = UIFont(name: fontName, size: size.rawValue) {
            return font
        } else {
            print("⚠️ الخط \(fontName) غير متوفر! تم استخدام الخط الافتراضي بدلاً عنه.")
            return UIFont.systemFont(ofSize: size.rawValue, weight: style.uiFontWeight)
        }
    }
    
    /// دالة مبسطة للحصول على الخط (تستخدم Cairo Regular كافتراضي)
    func font(size: Sizes) -> UIFont {
        return fontApp(family: .cairo, style: .regular, size: size)
    }
    
    /// دالة للحصول على خط عريض
    func boldFont(size: Sizes) -> UIFont {
        return fontApp(family: .cairo, style: .bold, size: size)
    }
    
    /// دالة للحصول على خط خفيف
    func lightFont(size: Sizes) -> UIFont {
        return fontApp(family: .cairo, style: .light, size: size)
    }
    
    // MARK: - الخطوط حسب الاستخدام
    
    /// خط العناوين الرئيسية
    var titleFont: UIFont {
        return fontApp(family: .cairo, style: .extraBold, size: .size_22)
    }
    
    /// خط العناوين الفرعية
    var subTitleFont: UIFont {
        return fontApp(family: .cairo, style: .bold, size: .size_18)
    }
    
    /// خط النصوص العادية
    var bodyFont: UIFont {
        return fontApp(family: .cairo, style: .regular, size: .size_16)
    }
    
    /// خط النصوص الصغيرة
    var captionFont: UIFont {
        return fontApp(family: .cairo, style: .regular, size: .size_12)
    }
    
    /// خط الأزرار
    var buttonFont: UIFont {
        return fontApp(family: .cairo, style: .extraBold, size: .size_16)
    }
    
    // تحديث الخطوط الموجودة ليصبح responsive
    var responsiveTitleFont: UIFont {
        return responsiveFont(family: .cairo, style: .extraBold, size: .size_22)
    }
    
    var responsiveSubTitleFont: UIFont {
        return responsiveFont(family: .cairo, style: .bold, size: .size_18)
    }
    
    var responsiveBodyFont: UIFont {
        return responsiveFont(family: .cairo, style: .regular, size: .size_16)
    }
    
    var responsiveButtonFont: UIFont {
        return responsiveFont(family: .cairo, style: .extraBold, size: .size_16)
    }
    
    var responsiveCaptionFont: UIFont {
        return responsiveFont(family: .cairo, style: .regular, size: .size_12)
    }

    
    // MARK: - الخطوط حسب اللغة

    func fontForCurrentLanguage(style: FontStyle, size: Sizes) -> UIFont {
        
        let currentLanguage = Locale.current.languageCode ?? "en"
        let family: Fonts
        
        switch currentLanguage {
        case "ar":
            family = .cairo // للعربية
        default:
            family = .cairo // يمكن تغييره للإنجليزية
        }
        
        return fontApp(family: family, style: style, size: size)

    }
    
    /// خط متجاوب - إضافة بسيطة للنظام الحالي
    func responsiveFont(family: Fonts = .cairo, style: FontStyle = .regular, size: Sizes) -> UIFont {
        let responsiveSize = size.responsive  // استخدام الخاصية الجديدة
        
        let fontName = "\(family.name)-\(style.rawValue)"
        
        if let font = UIFont(name: fontName, size: responsiveSize) {
            return font
        } else {
            return UIFont.systemFont(ofSize: responsiveSize, weight: style.uiFontWeight)
        }
    }

    
    /// التحقق من توفر جميع الخطوط المسجلة
    func printAvailableFonts() {
        print("--- الخطوط المتوفرة في النظام ---")
        for family in UIFont.familyNames.sorted() {
            print("عائلة الخط: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   - \(name)")
            }
        }
    }

    /// التحقق من حالة خط معين
    func checkFontAvailability(family: Fonts, style: FontStyle) -> Bool {
        let fontName = "\(family.name)-\(style.rawValue)"
        return UIFont(name: fontName, size: Sizes.size_10.rawValue) != nil
    }
    
    /// التحقق من توفر جميع خطوط التطبيق
    func validateAppFonts() {
        print("--- فحص خطوط التطبيق ---")
        
        for family in Fonts.allCases {
            print("فحص عائلة الخط: \(family.name)")
            
            for style in family.availableStyles {
                let isAvailable = checkFontAvailability(family: family, style: style)
                let status = isAvailable ? "✅ متوفر" : "❌ غير متوفر"
                print("   \(family.name)-\(style.rawValue): \(status)")
            }
        }
    }
    

    /// إنشاء تقرير مفصل عن الخطوط
    func generateFontReport() -> String {
        var report = "=== تقرير خطوط التطبيق ===\n\n"
        
        for family in Fonts.allCases {
            report += "📝 عائلة الخط: \(family.name)\n"
            report += "الوصف: \(family.description)\n"
            report += "الأوزان المتوفرة:\n"
            
            for style in family.availableStyles {
                let isAvailable = checkFontAvailability(family: family, style: style)
                let status = isAvailable ? "✅" : "❌"
                report += "   \(status) \(style.rawValue) - \(style.description)\n"
            }
            report += "\n"
        }
        
        return report
    }


}
