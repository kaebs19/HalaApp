//
//  NavigationDefaultActions.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 20/06/2025.
//

import UIKit

// MARK: - Navigation Default Actions
extension NavigationBarManager {
    
    /// الحصول على الإجراء الافتراضي للزر
    func getDefaultAction(for buttonType: NavigationButtonType) -> () -> Void {
        switch buttonType {
        case .back:
            return handleBackButton
        case .close:
            return handleCloseButton
        case .menu:
            return handleMenuButton
        case .more:
            return handleMoreButton
        case .done:
            return handleDoneButton
        case .cancel:
            return handleCancelButton
        case .next:
            return handleNextButton
        case .save:
            return handleSaveButton
        case .notificaiton:
            return handleNotificationButton
        case .search:
            return handleSearchButton
        case .info:
            return handleInfoButton
        case .help:
            return handleHelpButton
        case .skip:
            return handleSkipButton
        case .custom(_, _):
            return handleCustomButton
        }
    }
    
    // MARK: - Default Button Actions
    
    /// دالة زر الرجوع
    func handleBackButton() {
        print("🔙 \(#function) - تم الضغط على زر الرجوع")
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    /// دالة زر الإغلاق
    func handleCloseButton() {
        print("❌ \(#function) - تم الضغط على زر الإغلاق")
        if viewController?.navigationController?.viewControllers.count == 1 {
            viewController?.dismiss(animated: true)
        } else {
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
    
    /// دالة زر القائمة
    func handleMenuButton() {
        print("🍔 \(#function) - تم الضغط على زر القائمة")
        // يمكن إرسال notification أو استدعاء delegate
        NotificationCenter.default.post(name: .navigationMenuTapped, object: nil)
    }
    
    /// دالة زر المزيد
    func handleMoreButton() {
        print("⋯ \(#function) - تم الضغط على زر المزيد")
        // يمكن عرض action sheet
        showMoreActionSheet()
    }
    
    /// دالة زر الإنهاء
    func handleDoneButton() {
        print("✅ \(#function) - تم الضغط على زر الإنهاء")
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    /// دالة زر الإلغاء
    func handleCancelButton() {
        print("🚫 \(#function) - تم الضغط على زر الإلغاء")
        viewController?.dismiss(animated: true)
    }
    
    /// دالة زر التالي
    func handleNextButton() {
        print("➡️ \(#function) - تم الضغط على زر التالي")
        // يمكن استدعاء delegate أو navigation
        NotificationCenter.default.post(name: .navigationNextTapped, object: nil)
    }
    
    /// دالة زر الحفظ
    func handleSaveButton() {
        print("💾 \(#function) - تم الضغط على زر الحفظ")
        // يمكن استدعاء delegate للحفظ
        NotificationCenter.default.post(name: .navigationSaveTapped, object: nil)
    }
    
    /// دالة زر الإشعارات
    func handleNotificationButton() {
        print("🔔 \(#function) - تم الضغط على زر الإشعارات")
        // الانتقال لصفحة الإشعارات
        navigateToNotifications()
    }
    
    /// دالة زر البحث
    func handleSearchButton() {
        print("🔍 \(#function) - تم الضغط على زر البحث")
        // عرض شاشة البحث
        showSearchController()
    }
    
    /// دالة زر المعلومات
    func handleInfoButton() {
        print("ℹ️ \(#function) - تم الضغط على زر المعلومات")
        // عرض معلومات الصفحة
        showInfoAlert()
    }
    
    /// دالة زر المساعدة
    func handleHelpButton() {
        print("❓ \(#function) - تم الضغط على زر المساعدة")
        // عرض شاشة المساعدة
        navigateToHelp()
    }
    
    /// دالة زر التخطي
    func handleSkipButton() {
        print("⏭️ \(#function) - تم الضغط على زر التخطي")
        // تخطي الخطوة الحالية
        NotificationCenter.default.post(name: .navigationSkipTapped, object: nil)
    }
    
    /// دالة الزر المخصص
    func handleCustomButton() {
        print("🔧 \(#function) - تم الضغط على زر مخصص")
        // إجراء افتراضي للأزرار المخصصة
    }
    
    // MARK: - Helper Methods
    
    private func showMoreActionSheet() {
        guard let vc = viewController else { return }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // إضافة خيارات المزيد هنا
        actionSheet.addAction(UIAlertAction(title: "خيار 1", style: .default) { _ in
            print("تم اختيار الخيار 1")
        })
        
        actionSheet.addAction(UIAlertAction(title: "خيار 2", style: .default) { _ in
            print("تم اختيار الخيار 2")
        })
        
        actionSheet.addAction(UIAlertAction(title: "إلغاء", style: .cancel))
        
        vc.present(actionSheet, animated: true)
    }
    
    private func navigateToNotifications() {
        // يمكن استبدالها بالانتقال الفعلي لصفحة الإشعارات
        print("📱 الانتقال لصفحة الإشعارات")
    }
    
    private func showSearchController() {
        guard let vc = viewController else { return }
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "بحث..."
        vc.navigationItem.searchController = searchController
        vc.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func showInfoAlert() {
        guard let vc = viewController else { return }
        
        let alert = UIAlertController(
            title: "معلومات",
            message: "معلومات حول هذه الصفحة",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "موافق", style: .default))
        vc.present(alert, animated: true)
    }
    
    private func navigateToHelp() {
        // يمكن استبدالها بالانتقال الفعلي لصفحة المساعدة
        print("🆘 الانتقال لصفحة المساعدة")
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let navigationMenuTapped = Notification.Name("navigationMenuTapped")
    static let navigationNextTapped = Notification.Name("navigationNextTapped")
    static let navigationSaveTapped = Notification.Name("navigationSaveTapped")
    static let navigationSkipTapped = Notification.Name("navigationSkipTapped")
}
