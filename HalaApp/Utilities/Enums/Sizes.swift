//
//  Sizes.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 06/06/2025.
//

import Foundation
import UIKit

enum Sizes: CGFloat, CaseIterable {

    // أحجام صغيرة
    case size_8 = 8.0
    case size_9 = 9.0
    case size_10 = 10.0
    case size_11 = 11.0
    case size_12 = 12.0
    
    // أحجام متوسطة
    case size_13 = 13.0
    case size_14 = 14.0
    case size_15 = 15.0
    case size_16 = 16.0
    case size_17 = 17.0
    case size_18 = 18.0
    
    // أحجام كبيرة
    case size_20 = 20.0
    case size_22 = 22.0
    case size_24 = 24.0
    case size_26 = 26.0
    case size_28 = 28.0
    case size_30 = 30.0
    
    // أحجام العناوين
    case size_32 = 32.0
    case size_34 = 34.0
    case size_36 = 36.0
    case size_40 = 40.0
    case size_44 = 44.0
    case size_48 = 48.0

    
    var description: String {
            switch self {
            case .size_8, .size_9, .size_10, .size_11, .size_12:
                return "حجم صغير - للنصوص الفرعية"
            case .size_13, .size_14, .size_15, .size_16, .size_17, .size_18:
                return "حجم متوسط - للنصوص العادية"
            case .size_20, .size_22, .size_24, .size_26, .size_28, .size_30:
                return "حجم كبير - للعناوين الفرعية"
            case .size_32, .size_34, .size_36, .size_40, .size_44, .size_48:
                return "حجم كبير جداً - للعناوين الرئيسية"
            }
        }
    
    /// تصنيف الحجم
    var category: FontSizeCategory {
        switch self {
        case .size_8, .size_9, .size_10, .size_11, .size_12:
            return .small
        case .size_13, .size_14, .size_15, .size_16, .size_17, .size_18:
            return .medium
        case .size_20, .size_22, .size_24, .size_26, .size_28, .size_30:
            return .large
        case .size_32, .size_34, .size_36, .size_40, .size_44, .size_48:
            return .extraLarge
        }
    }
    
    /// حجم متجاوب حسب الجهاز - إضافة بسيطة
    var responsive: CGFloat {
        let baseSize = self.rawValue
        
        
        // تقليل بسيط للـ iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            return baseSize * 0.9  // تقليل 10% فقط
        }
        
        return baseSize
    }
    
    /// حجم مخصص حسب الجهاز
    func custom(iPhone: CGFloat? = nil , iPad: CGFloat? = nil) -> CGFloat {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return iPad ?? (self.rawValue * 0.9)
        }
        
        return iPhone ?? self.rawValue

    }

}

/// تصنيفات أحجام الخطوط
enum FontSizeCategory: String, CaseIterable {
    case small = "صغير"
    case medium = "متوسط"
    case large = "كبير"
    case extraLarge = "كبير جداً"
}
