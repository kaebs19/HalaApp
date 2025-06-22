//
//  NativeMessagesManager+Types.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - Message Types & Configuration
extension NativeMessagesManager {
    
    /// أنواع الرسائل المختلفة
    enum MessageType {
        case success
        case error
        case warning
        case info
        case loading
        case custom(backgroundColor: UIColor, textColor: UIColor, icon: UIImage?)
        
        /// التحقق من نوع التحميل
        var isLoading: Bool {
            switch self {
            case .loading: return true
            default: return false
            }
        }
        
        /// لون الخلفية للرسالة
        var backgroundColor: UIColor {
            switch self {
            case .success: return UIColor.systemGreen
            case .error: return UIColor.systemRed
            case .warning: return UIColor.systemOrange
            case .info: return UIColor.systemBlue
            case .loading: return UIColor.systemBlue
            case .custom(let bgColor, _, _): return bgColor
            }
        }
        
        /// لون النص
        var textColor: UIColor {
            switch self {
            case .success, .error, .warning, .info, .loading: return UIColor.white
            case .custom(_, let textColor, _): return textColor
            }
        }
        
        /// الأيقونة المناسبة
        var icon: UIImage? {
            switch self {
            case .success: return UIImage(systemName: "checkmark.circle.fill")
            case .error: return UIImage(systemName: "xmark.circle.fill")
            case .warning: return UIImage(systemName: "exclamationmark.triangle.fill")
            case .info: return UIImage(systemName: "info.circle.fill")
            case .loading: return nil
            case .custom(_, _, let icon): return icon
            }
        }
        
        /// نوع الاهتزاز المناسب
        var hapticType: HapticManager.HapticFeedbackType? {
            switch self {
            case .success: return .success
            case .error: return .error
            case .warning: return .warning
            case .info, .loading: return .light
            case .custom: return .light
            }
        }
    }
    
    /// مواضع عرض الرسائل
    enum Position {
        case top
        case bottom
        case center
    }
    
    /// إعدادات عرض الرسالة
    struct MessageConfiguration {
        /// مدة عرض الرسالة (-1 للعرض المستمر)
        var duration: TimeInterval = DefaultSettings.displayDuration
        /// موضع العرض
        var position: Position = .top
        /// تفعيل الاهتزاز
        var enableHaptic: Bool = true
        /// تعتيم الخلفية
        var dimBackground: Bool = false
        /// إمكانية التفاعل (الضغط للإخفاء)
        var isInteractive: Bool = true
        
        /// الإعدادات الافتراضية
        static let `default` = MessageConfiguration()
    }
}
