//
//  UserStatus.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/07/2025.
//

import UIKit


// MARK: - User Status System
/// نظام حالات المستخدم - يدير الحالات المختلفة مع الألوان والأيقونات

enum UserStatus: String , CaseIterable {
    
    case available = "متاح"       // أخضر
    case busy = "مشغول"          // أصفر/برتقالي
    case offline = "مغلق"        // أحمر

    // MARK: - Display Properties
    
    /// الاسم المعروض للحالة
    var displayName: String {
        return self.rawValue
    }
    
    /// لون الحالة
    var color: UIColor {
        switch self {
            case .available:
                return UIColor.systemGreen
            case .busy:
                return UIColor.systemOrange
            case .offline:
                return UIColor.systemRed
        }
    }
    
    /// أيقونة الحالة (دائرة ملونة)
    var statusIcon: UIImage {
        // إنشاء دائرة ملونة كأيقونة للحالة
        return createCircleIcon(color: color, size: 12)

    }
    
    /// أيقونة أكبر للعرض
    var largeStatusIcon: UIImage {
        return createCircleIcon(color: color, size: 16)
    }
    
    // MARK: - Helper Methods
    
    /// إنشاء أيقونة دائرية ملونة
    private func createCircleIcon(color: UIColor, size: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { context in
            color.setFill()
            context.cgContext.fillEllipse(in: CGRect(x: 0, y: 0, width: size, height: size))
        }
    }
    
    /// الحصول على الحالة من النص
    static func from(string: String) -> UserStatus {
        return UserStatus(rawValue: string) ?? .offline
    }

    
}
