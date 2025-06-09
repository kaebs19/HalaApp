//
//  FontStyle.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 06/06/2025.
//

import Foundation
import UIKit

/// تعداد أوزان الخطوط المتوفرة
enum FontStyle: String, CaseIterable {
    case black = "Black"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case extraLight = "ExtraLight"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semiBold = "SemiBold"
    
    /// تحويل وزن الخط إلى UIFont.Weight
    var uiFontWeight: UIFont.Weight {
        switch self {
        case .black:
            return .black
        case .bold:
            return .bold
        case .extraBold:
            return .heavy
        case .extraLight:
            return .ultraLight
        case .light:
            return .light
        case .medium:
            return .medium
        case .regular:
            return .regular
        case .semiBold:
            return .semibold
        }
    }
    
    /// وصف الوزن
    var description: String {
        switch self {
        case .black:
            return "أسود - الأثقل"
        case .bold:
            return "عريض"
        case .extraBold:
            return "عريض جداً"
        case .extraLight:
            return "خفيف جداً"
        case .light:
            return "خفيف"
        case .medium:
            return "متوسط"
        case .regular:
            return "عادي"
        case .semiBold:
            return "نصف عريض"
        }
    }
}
