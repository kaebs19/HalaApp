//
//  NavigationConvenienceTypes.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 20/06/2025.
//

import Foundation

// MARK: - Convenience Button Types 
extension NavigationButtonType {
    
    // MARK: - Back Button Variants
    static let backIcon = NavigationButtonType.back(showTitle: false)
    static let backText = NavigationButtonType.back(showTitle: true)
    
    // MARK: - Close Button Variants
    static let closeIcon = NavigationButtonType.close(showTitle: false)
    static let closeText = NavigationButtonType.close(showTitle: true)
    
    // MARK: - Menu Button Variants
    static let menuIcon = NavigationButtonType.menu(showTitle: false)
    static let menuText = NavigationButtonType.menu(showTitle: true)
    
    // MARK: - Save Button Variants
    static let saveIcon = NavigationButtonType.save(showTitle: false)
    static let saveText = NavigationButtonType.save(showTitle: true)
    
    // MARK: - More Button Variants
    static let moreIcon = NavigationButtonType.more(showTitle: false)
    static let moreText = NavigationButtonType.more(showTitle: true)
    
    // MARK: - Search Button Variants
    static let searchIcon = NavigationButtonType.search(showTitle: false)
    static let searchText = NavigationButtonType.search(showTitle: true)
    
    // MARK: - Notification Button Variants
    static let notificationIcon = NavigationButtonType.notificaiton(showTitle: false)
    static let notificationText = NavigationButtonType.notificaiton(showTitle: true)
    
    // MARK: - Done Button Variants
    static let doneIcon = NavigationButtonType.done(showTitle: false)
    static let doneText = NavigationButtonType.done(showTitle: true)
    
    // MARK: - Cancel Button Variants
    static let cancelIcon = NavigationButtonType.cancel(showTitle: false)
    static let cancelText = NavigationButtonType.cancel(showTitle: true)
    
    // MARK: - Next Button Variants
    static let nextIcon = NavigationButtonType.next(showTitle: false)
    static let nextText = NavigationButtonType.next(showTitle: true)
    
    // MARK: - Info Button Variants
    static let infoIcon = NavigationButtonType.info(showTitle: false)
    static let infoText = NavigationButtonType.info(showTitle: true)
    
    // MARK: - Help Button Variants
    static let helpIcon = NavigationButtonType.help(showTitle: false)
    static let helpText = NavigationButtonType.help(showTitle: true)
    
    // MARK: - Skip Button Variants
    static let skipIcon = NavigationButtonType.skip(showTitle: false)
    static let skipText = NavigationButtonType.skip(showTitle: true)
}

// MARK: - Usage Examples Guide
/*
 
 📱 أمثلة الاستخدام الجديدة:
 ==========================
 
 // 1️⃣ زر رجوع بأيقونة فقط
 setNavigationButtons(items: [.backIcon], title: .signup)
 
 // 2️⃣ زر رجوع بنص فقط
 setNavigationButtons(items: [.backText], title: .signup)
 
 // 3️⃣ مزج بين الأيقونات والنصوص
 setNavigationButtons(items: [.backIcon, .saveText], title: .profile)
 
 // 4️⃣ الطريقة الكاملة (مرنة أكثر)
 setNavigationButtons(items: [.back(showTitle: true), .save(showTitle: false)], title: .settings)
 
 // 5️⃣ مقارنة سريعة:
 // أيقونة فقط:
 setNavigationButtons(items: [.backIcon])
 
 // نص فقط:
 setNavigationButtons(items: [.backText])
 
 // الطريقة التقليدية (نفس النتيجة):
 setNavigationButtons(items: [.back(showTitle: false)]) // أيقونة
 setNavigationButtons(items: [.back(showTitle: true)])  // نص
 
 */
