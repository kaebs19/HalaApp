//
//  UserStatusManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/07/2025.
//

import UIKit

// MARK: - User Status Manager
/// مدير حالات المستخدم - يدير تغيير وحفظ الحالات

class UserStatusManager {

    
    static let shared = UserStatusManager()
    
    private init() {}
    
    /// الحالة الحالية للمستخدم
    @UserDefault("current_user_status", defaultValue: "مغلق")
    private static var currentStatusRaw: String

    /// الحصول على الحالة الحالية
    static var currentStatus: UserStatus {
        
        get {
            return UserStatus.from(string: currentStatusRaw)
        }
        
        set {
            currentStatusRaw = newValue.rawValue
            NotificationCenter.default.post(
                name: .userStatusDidChange,
                object: newValue
            )
        }
    }
 
    // MARK: - Public Methods
    
    /// تغيير حالة المستخدم
    func changeStatus( to status: UserStatus) {
        UserStatusManager.currentStatus = status
        print("🔄 تم تغيير حالة المستخدم إلى: \(status.displayName)")
    }
    
    /// الحصول على جميع الحالات المتاحة
    func getAllStatuses() -> [UserStatus] {
        return UserStatus.allCases
    }
    
    /// تبديل الحالة للحالة التالية
    func toggleToNextStatus() {
        let allStatuses = UserStatus.allCases
        let currentIndex = allStatuses.firstIndex(of: UserStatusManager.currentStatus) ?? 0
        let nextIndex = (currentIndex + 1) % allStatuses.count
        let nextStatus = allStatuses[nextIndex]
        
        changeStatus(to: nextStatus)

    }
    
}
