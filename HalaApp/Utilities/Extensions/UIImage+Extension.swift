//
//  UIImage+Extension.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

extension UIImage {
    
    /// تغيير لون الصورة
    func withTintColor(_ color: AppColors) -> UIImage {
        return self.withTintColor(color.color, renderingMode: .alwaysOriginal)
    }
    
    /// تغيير حجم الصورة
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// قص الصورة لتصبح دائرية
        func circularImage(with diameter: CGFloat) -> UIImage? {
            let size = CGSize(width: diameter, height: diameter)
            
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            defer { UIGraphicsEndImageContext() }
            
            let context = UIGraphicsGetCurrentContext()
            let rect = CGRect(origin: .zero, size: size)
            
            // إنشاء مسار دائري
            context?.addEllipse(in: rect)
            context?.clip()
            
            // رسم الصورة داخل الدائرة
            draw(in: rect)
            
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    
}
