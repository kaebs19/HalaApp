//
//  UserRank.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/07/2025.
//

import UIKit

enum UserRank: String, CaseIterable {
    case newUser
    case activeUser
    case premiumUser
    case vipUser
    case moderator
    case admin
    
    // MARK: - Display Properties
    var displayName: String {
        let isEnglish = LanguageManager.shared.isEnglish()

        switch self {

        case .newUser:
            return isEnglish ? "New user" : "مستخدم جديد"
        case .activeUser:
            return isEnglish ? "Active user" : "مستخدم متفاعل"
        case .premiumUser:
            return isEnglish ? "Premium user" : "مستخدم مميز"
        case .vipUser:
            return isEnglish ? "VIP user" : "مستخدم VIP"
        case .moderator:
            return isEnglish ? "Moderator" : "مشرف"
        case .admin:
            return isEnglish ? "Admin" : "مدير"
        }

    }
    
    /// لون الرتبة
      var color: UIColor {
          switch self {
          case .newUser:
              return UIColor.systemGray2
          case .activeUser:
              return UIColor.systemBlue
          case .premiumUser:
              return UIColor.systemPurple
          case .vipUser:
              return UIColor.systemOrange
          case .moderator:
              return UIColor.systemRed
          case .admin:
              return UIColor.systemPink
          }
      }
    
    /// أيقونة الرتبة
    var icon: String {
        switch self {
        case .newUser:
            return "person.badge.plus"
        case .activeUser:
            return "hand.thumbsup.fill"
        case .premiumUser:
            return "star.fill"
        case .vipUser:
            return "crown.fill"
        case .moderator:
            return "shield.fill"
        case .admin:
            return "person.3.fill"
        }
    }
    
    
    /// الحد الأدنى من النقاط للوصول لهذه الرتبة
    var requiredPoints: Int {
        switch self {
        case .newUser: return 0
        case .activeUser: return 50
        case .premiumUser: return 500
        case .vipUser: return 1000
        case .moderator: return 2000
        case .admin: return 5000
        }
    }
    
    /// وصف الرتبة
    var description: String {
        switch self {
        case .newUser:
            return "مرحباً بك في التطبيق!"
        case .activeUser:
            return "مستخدم نشط ومتفاعل"
        case .premiumUser:
            return "عضوية مميزة مع امتيازات خاصة"
        case .vipUser:
            return "عضو VIP مع امتيازات حصرية"
        case .moderator:
            return "مشرف المجتمع"
        case .admin:
            return "مدير التطبيق"
        }
    }

      /// لون الخلفية للرتبة (أفتح)
      var backgroundColor: UIColor {
          return color.withAlphaComponent(0.15)
      }
    
    // MARK: - Static Methods
    
    /// تحديد الرتبة حسب النقاط
    static func getRank(for points: Int) -> UserRank {
          let sortedRanks = UserRank.allCases.sorted { $0.requiredPoints > $1.requiredPoints }
          
          for rank in sortedRanks {
              if points >= rank.requiredPoints {
                  return rank
              }
          }
          
          return .newUser
      }
    
    /// الحصول على الرتبة من النص
    static func from(string: String) -> UserRank {
        return UserRank(rawValue: string) ?? .newUser
    }

}


