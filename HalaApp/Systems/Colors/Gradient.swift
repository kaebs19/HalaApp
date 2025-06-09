//
//  Gradient.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import Foundation
import UIKit


enum Gradients: String {
    
    case orange = "GradientOrange"
    case clear = "Clear"
    
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
}
