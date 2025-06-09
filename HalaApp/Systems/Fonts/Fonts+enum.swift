//
//  Fonts+enum.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 06/06/2025.
//

import Foundation

/// تعداد عائلات الخطوط المتوفرة في التطبيق
enum Fonts: String , CaseIterable {
        case cairo = "Cairo"
        case tajawal = "Tajawal"
    
    /// اسم عائلة الخط
    var name: String {
        return self.rawValue
    }
    
    /// وصف عائلة الخط
    var description: String {
        switch self {
            case .cairo:
                return "خط Cairo - مناسب للنصوص العربية والإنجليزية"
            case .tajawal:
                return "خط Tajawal - خط عربي حديث وأنيق"
        }
    }
    
    /// الأوزان المتوفرة لكل عائلة خط
    var availableStyles: [FontStyle] {
        switch self {
                
            case .cairo:
                return [.black, .bold, .extraBold, .light, .medium, .regular, .semiBold]

            case .tajawal:
                return [.black, .bold, .extraBold, .extraLight, .light, .medium, .regular]
        }
    }
}
