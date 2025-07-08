//
//  UserRankManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/07/2025.
//

import UIKit


// MARK: - User Rank Manager
/// مدير رتب المستخدمين
class UserRankManager {
    
    // MARK: - Properties
    static let shared = UserRankManager()
    private init() {}
    
    /// نقاط المستخدم الحالية
    @UserDefault("user_points", defaultValue: 0)
    static var userPoints: Int {
        didSet {
            // تحديث الرتبة تلقائياً عند تغيير النقاط
            let newRank = UserRank.getRank(for: userPoints)
            if newRank != currentRank {
                currentRank = newRank
            }
        }
    }
    
    /// الرتبة الحالية للمستخدم
    @UserDefault("current_user_rank", defaultValue: "مستخدم جديد")
    private static var currentRankRaw: String
    
    /// الحصول على الرتبة الحالية
    static var currentRank: UserRank {
        get {
            return UserRank.from(string: currentRankRaw)
        }
        set {
            currentRankRaw = newValue.rawValue
            NotificationCenter.default.post(
                name: .userRankDidChange,
                object: newValue
            )
        }
    }
    
    // MARK: - Public Methods
    
    /// إضافة نقاط للمستخدم
    func addPoints(_ points: Int) {
        let oldRank = UserRankManager.currentRank
        UserRankManager.userPoints += points
        let newRank = UserRankManager.currentRank
        
        print("➕ تم إضافة \(points) نقطة. المجموع: \(UserRankManager.userPoints)")
        
        // إشعار بترقية الرتبة
        if newRank != oldRank {
            NotificationCenter.default.post(
                name: .userRankUpgraded,
                object: newRank,
                userInfo: ["oldRank": oldRank, "newRank": newRank]
            )
            print("🎉 تم ترقية الرتبة من \(oldRank.displayName) إلى \(newRank.displayName)")
        }
    }
    
    /// النقاط المطلوبة للرتبة التالية
    func pointsToNextRank() -> Int? {
        let currentRank = UserRankManager.currentRank
        let allRanks = UserRank.allCases.sorted { $0.requiredPoints < $1.requiredPoints }
        
        guard let currentIndex = allRanks.firstIndex(of: currentRank),
              currentIndex < allRanks.count - 1 else {
            return nil // أعلى رتبة
        }
        
        let nextRank = allRanks[currentIndex + 1]
        let pointsNeeded = nextRank.requiredPoints - UserRankManager.userPoints
        return max(pointsNeeded, 0)
    }
    
    /// نسبة التقدم للرتبة التالية (0.0 - 1.0)
    func progressToNextRank() -> Float {
        let currentRank = UserRankManager.currentRank
        let allRanks = UserRank.allCases.sorted { $0.requiredPoints < $1.requiredPoints }
        
        guard let currentIndex = allRanks.firstIndex(of: currentRank),
              currentIndex < allRanks.count - 1 else {
            return 1.0 // أعلى رتبة
        }
        
        let nextRank = allRanks[currentIndex + 1]
        let currentPoints = UserRankManager.userPoints
        let currentRankPoints = currentRank.requiredPoints
        let nextRankPoints = nextRank.requiredPoints
        
        let progress = Float(currentPoints - currentRankPoints) / Float(nextRankPoints - currentRankPoints)
        return max(0.0, min(1.0, progress))
    }

}
