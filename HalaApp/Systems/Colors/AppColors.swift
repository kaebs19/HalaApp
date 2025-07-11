//
//  AppColors.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 06/06/2025.
//

import UIKit

enum AppColors: String, CaseIterable {
    
    // ألوان أساسية
    case background = "Background"
    case text = "Text"
    case primary = "Primary"
    case secondary = "Secondary"
    case accent = "Accent"
    case textSecondary = "TextSecondary"
    case secondBackground = "SecondBackground"
    case placeholder = "Placeholder"
    case separator = "Separator"
    case tintIcon = "TintIcon"

    
    // الوان اظافية
    case success = "Success"
    case warning = "Warning"
    case error = "Error"
    
    // إضافات من النظام الحالي
    case mainBackground = "MainBackground"
    case textColor = "TextColor"
    case buttonText = "ButtonText"
    case tabBar = "TabBar"
    case clear = "Clear"
    case boarderColor = "BoarderColor"
    case onlyRed = "OnlyRed"
    
    
    /// الحصول على لون UIColor من ملف الألوان
    var color: UIColor {
        if self == .clear {
            return UIColor.clear
        }
        
        // محاولة الحصول على اللون من ملف الألوان
        if let color = UIColor(named: self.rawValue) {
            return color
        }
        
        // محاولة الحصول على اللون من ملف الألوان
        guard let color = UIColor(named: self.rawValue) else {
            print("⚠️ اللون \(self.rawValue) غير موجود في Assets")
            return UIColor.clear
        }
        return color

    }
    
    
    /// ألوان بديلة في حالة عدم وجود اللون في Assets
    private var fallbackColor: UIColor {
        
        switch self {
        case .background, .mainBackground:
            return UIColor.systemBackground
        case .text, .textColor:
            return UIColor.label
        case .primary:
            return UIColor.systemBlue
        case .secondary:
            return UIColor.secondaryLabel
        case .accent:
            return UIColor.systemBlue
        case .success:
            return UIColor.systemGreen
        case .warning:
            return UIColor.systemYellow
        case .error:
            return UIColor.systemRed
        case .buttonText:
            return UIColor.white
        case .tabBar:
            return UIColor.systemBackground
        case .clear:
            return UIColor.clear
            case .textSecondary:
                return UIColor.systemGray4
            case .secondBackground:
                return UIColor.systemGray5
            case .placeholder:
                return UIColor.systemGray6
            case .boarderColor:
                return UIColor.systemOrange
            case .separator:
                return UIColor.systemGray2
            case .tintIcon:
              return   UIColor.systemBackground
            case .onlyRed:
                return UIColor.systemRed
        }
    }
}
