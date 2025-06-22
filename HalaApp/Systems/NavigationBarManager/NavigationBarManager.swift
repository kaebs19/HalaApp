//
//  NavigationBarManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 20/06/2025.
//

import UIKit

// MARK: - Navigation Configuration

struct NavigationConfig {
    var title: String?
    var isLargeTitleEnabled: Bool = false
    var leftButton: NavigationButton?
    var rightButton: NavigationButton?
    var backgroundColor: AppColors = .background
    var titleColor: AppColors = .text
    var tintColor: AppColors = .primary
    var hideNavigationBar: Bool = false
    var isTranslucent: Bool = true
    
    static let `default` = NavigationConfig()
}


// MARK: - Navigation Button Types
 enum NavigationButtonType {
     case back
     case close
     case custom(icon: String , title: String? = nil)
     case menu
     case more
     case done
     case cancel
     case next
     case save
     case notificaiton
     case search
     case info
     case help
     case skip
     
     var iconName: String {
         switch self {
             case .back:
                 return LanguageManager.shared.isEnglish() ? "chevron.left" : "chevron.right"
                 
             case .close:
                 return Images.close.imageName
                 
             case .custom(icon: let icon, _):
                 return icon
                 
             case .menu:
                 return Images.menu.imageName
                 
             case .more:
                 return Images.morefill.imageName
                 
             case .done:
                 return "checkmark"
                 
             case .cancel:
                 return "xmark"

             case .next:
                 return LanguageManager.shared.isEnglish() ? "chevron.right" : "chevron.left"

             case .save:
                 return Images.save.imageName
                 
             case .notificaiton:
                 return Images.notification.imageName
                 
             case .search:
                 return Images.search.imageName
                 
             case .info:
                 return "info.circle"

             case .help:
                 return "questionmark.circle"

             case .skip:
                 return "forward.fill"
         }
     }
     
     var title: String? {
      
         switch self {
                 
             case .back:
                 return LanguageManager.shared.isEnglish() ? "Back" : "رجوع"
             case .close:
                 return LanguageManager.shared.isEnglish() ? "Close" : "إغلاق"
             case .custom(_, let title):
                 return title
             case .menu:
                 return LanguageManager.shared.isEnglish() ? "Menu" : "القائمة"
             case .more:
                 return LanguageManager.shared.isEnglish() ? "More" : "المزيد"
             case .done:
                 return LanguageManager.shared.isEnglish() ? "Done" : "إنهاء"
             case .cancel:
                 return LanguageManager.shared.isEnglish() ? "Cancel" : "الغاء"
             case .next:
                 return LanguageManager.shared.isEnglish() ? "Next" : "التالي"
             case .save:
                 return LanguageManager.shared.isEnglish() ? "Save" : "حفظ"
             case .notificaiton:
                 return LanguageManager.shared.isEnglish() ? "Notifications" : "الإشعارات"
             case .search:
                 return LanguageManager.shared.isEnglish() ? "Search" : "بحث"
             case .info:
                 return LanguageManager.shared.isEnglish() ? "Info" : "معلومات"
             case .help:
                 return LanguageManager.shared.isEnglish() ? "Help" : "مساعدة"
             case .skip:
                 return LanguageManager.shared.isEnglish() ? "Skip" : "تخطي"
         }
     }
}

// MARK: - Navigation Button Configuration
struct NavigationButton {
    
    let type: NavigationButtonType
    let action: (() -> Void)?
    let isEnabled: Bool
    let badge: String?
    
    init(type: NavigationButtonType, action: (() -> Void)?, isEnabled: Bool = true, badge: String? = nil) {
        self.type = type
        self.action = action
        self.isEnabled = isEnabled
        self.badge = badge
    }
}

// MARK: - Navigation Bar Manager
class NavigationBarManager {
    
    
    // MARK: - Properties
    private weak var viewController: UIViewController?
    private var currentConfig:  NavigationConfig?
    
    // MARK: - Initialization
        init(viewController: UIViewController) {
            self.viewController = viewController
    }
    
    
    // MARK: - Public Methods
        
    /// إعداد شريط التنقل مع التكوين المحدد
    func configure(with config: NavigationConfig) {
        guard let vc = viewController else { return }
        
        currentConfig = config
        
        // إخفاء/إظهار شريط التنقل
        if config.hideNavigationBar {
            vc.navigationController?.setNavigationBarHidden(true, animated: true)
            return
        } else {
            vc.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        // إعداد العنوان
        setupTitle(config: config)
        
        // إعداد الأزرار
        setupButtons(config: config)
        
        // إعداد المظهر
        setupAppearance(config: config)

    }
    
    /// إعداد سريع للعنوان فقط
    func setTitle(_ title: String, isLarge: Bool = false) {
        var config = currentConfig ?? .default
            config.title = title
            config.isLargeTitleEnabled = isLarge
            configure(with: config)
    }
    
    /// إعداد سريع لزر الرجوع
    func setBackButton(action: (() -> Void)? = nil) {
        var config = currentConfig ?? .default
        config.leftButton = NavigationButton(type: .back, action: action ?? defaultBackAction)
        configure(with: config)
    }
    
    /// إعداد سريع لزر الإغلاق
    func setCloseButton(action: (() -> Void)? = nil) {
        var config = currentConfig ?? .default
        config.leftButton = NavigationButton(type: .close, action: action ?? defaultCloseAction)
        configure(with: config)
    }
    
    /// إعداد سريع لزر في الجهة اليمنى
    func setRightButton(type: NavigationButtonType, action: @escaping () -> Void) {
        var config = currentConfig ?? .default
            config.rightButton = NavigationButton(type: type, action: action)
            configure(with: config)
    }
    
    
    // MARK: - Private Methods
    
    private func setupTitle(config: NavigationConfig) {
        guard let vc = viewController else { return }
        
        if let title = config.title {
            vc.navigationItem.title = title
        }
        
        // إعداد العنوان الكبير
        vc.navigationController?.navigationBar.prefersLargeTitles = config.isLargeTitleEnabled
        vc.navigationItem.largeTitleDisplayMode = config.isLargeTitleEnabled ? .always : .never
    }
    
    private func setupButtons(config: NavigationConfig) {
        guard let vc = viewController else { return }
        
        // إعداد الزر الأيسر
        if let leftButton = config.leftButton {
            vc.navigationItem.leftBarButtonItem = createBarButtonItem(from: leftButton)
        } else {
            vc.navigationItem.leftBarButtonItem = nil
        }
        
        // إعداد الزر الأيمن
        if let rightButton = config.rightButton {
            vc.navigationItem.rightBarButtonItem = createBarButtonItem(from: rightButton)
        } else {
            vc.navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func createBarButtonItem(from button: NavigationButton) -> UIBarButtonItem {
        let barButtonItem: UIBarButtonItem
        
        // إنشاء الزر حسب النوع
        if let title = button.type.title, !title.isEmpty {
            barButtonItem = UIBarButtonItem(
                title: title,
                style: .plain,
                target: self,
                action: #selector(buttonTapped(_:))
            )
        } else {
            let image = UIImage(systemName: button.type.iconName)
            barButtonItem = UIBarButtonItem(
                image: image,
                style: .plain,
                target: self,
                action: #selector(buttonTapped(_:))
            )
        }
        
        // حفظ الإجراء والحالة
        barButtonItem.tag = ObjectIdentifier(button as AnyObject).hashValue
        objc_setAssociatedObject(barButtonItem, &AssociatedKeys.buttonAction, button.action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        barButtonItem.isEnabled = button.isEnabled
        
        // إضافة البادج إذا وجد
        if let badge = button.badge {
            addBadge(to: barButtonItem, text: badge)
        }
        
        return barButtonItem
    }

    
    private func setupAppearance(config: NavigationConfig) {
        guard let navigationBar = viewController?.navigationController?.navigationBar else { return }
        
        let appearance = UINavigationBarAppearance()
    
        if config.isTranslucent {
            appearance.configureWithDefaultBackground()
        } else {
            appearance.configureWithOpaqueBackground()
        }
        
        appearance.backgroundColor = config.backgroundColor.color
        appearance.titleTextAttributes = [.foregroundColor: config.titleColor.color]
        appearance.largeTitleTextAttributes = [.foregroundColor: config.titleColor.color]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = config.titleColor.color
    }
    
    private func addBadge(to barButtonItem: UIBarButtonItem , text: String) {
        // يمكن تحسينها لاحقاً لإضافة بادج مخصص
        // حالياً نضيف النص للعنوان
        if let currentTitle = barButtonItem.title {
            barButtonItem.title = "\(currentTitle) (\(text))"
        }
    }
    
    
     @objc private func buttonTapped(_ sender: UIBarButtonItem) {
         if let action = objc_getAssociatedObject(sender, &AssociatedKeys.buttonAction) as? (() -> Void) {
             action()
         }
     }
    
    // MARK: - Default Actions
    private func defaultBackAction() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    private func defaultCloseAction() {
        if viewController?.navigationController?.viewControllers.count == 1 {
            viewController?.dismiss(animated: true)
        } else {
            viewController?.navigationController?.popViewController(animated: true)
    }
    }
}

// MARK: - Associated Keys
private struct AssociatedKeys {
    static var buttonAction = "buttonAction"
}

// MARK: - UIViewController Extension
extension UIViewController {
    
    private var navigationManager: NavigationBarManager {
        if let manager = objc_getAssociatedObject(self, &AssociatedKeys.navigationManager) as? NavigationBarManager {
            return manager
        }
        
        let manager = NavigationBarManager(viewController: self)
        objc_setAssociatedObject(self, &AssociatedKeys.navigationManager, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return manager

    }
    
    /// إعداد شريط التنقل مع تكوين مخصص
    func setupNavigationBar(with config: NavigationConfig) {
        navigationManager.configure(with: config)
    }
    
    /// إعداد سريع للعنوان
    func setNavigationTitle(_ title: Title, isLarge: Bool = false) {
        navigationManager.setTitle(title.TextTitle, isLarge: isLarge)
    }
    
    /// إعداد سريع للعنوان نص مخصص
    func setNavigationTitle(_ title: String, isLarge: Bool = false) {
        navigationManager.setTitle(title, isLarge: isLarge)
    }
    
    /// إعداد سريع لزر الرجوع
    func setNavigationBackButton(action: (() -> Void)? = nil) {
           navigationManager.setBackButton(action: action)
    }
    
    /// إعداد سريع لزر الإغلاق
    func setNavigationCloseButton(action: (() -> Void)? = nil) {
        navigationManager.setCloseButton(action: action)
    }

    /// إعداد سريع لزر في الجهة اليمنى
    func setNavigationRightButton(type: NavigationButtonType, action: @escaping () -> Void) {
        navigationManager.setRightButton(type: type, action: action)
    }

    /// إخفاء شريط التنقل
    func hideNavigationBar(animated: Bool = true) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    /// إظهار شريط التنقل
    func showNavigationBar(animated: Bool = true) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

// MARK: - Associated Keys Extension
private extension AssociatedKeys {
    static var navigationManager = "navigationManager"
}


// MARK: - Quick Setup Examples
/*
 
 📱 أمثلة الاستخدام:
 =================
 
 // 1️⃣ إعداد بسيط للعنوان فقط
 setNavigationTitle(.settings)
 
 // 2️⃣ إعداد عنوان كبير
 setNavigationTitle(.home, isLarge: true)
 
 // 3️⃣ إعداد زر رجوع
 setNavigationBackButton()
 
 // 4️⃣ إعداد زر رجوع مع إجراء مخصص
 setNavigationBackButton {
     // إجراء مخصص قبل الرجوع
     print("حفظ البيانات...")
     navigationController?.popViewController(animated: true)
 }
 
 // 5️⃣ إعداد زر إغلاق
 setNavigationCloseButton()
 
 // 6️⃣ إعداد زر في الجهة اليمنى
 setNavigationRightButton(type: .save) {
     saveData()
 }
 
 // 7️⃣ إعداد مخصص كامل
 let config = NavigationConfig(
     title: "الرسائل",
     isLargeTitleEnabled: true,
     leftButton: NavigationButton(type: .back) { [weak self] in
         self?.navigationController?.popViewController(animated: true)
     },
     rightButton: NavigationButton(type: .more) { [weak self] in
         self?.showMoreOptions()
     },
     backgroundColor: .background,
     titleColor: .text,
     tintColor: .primary
 )
 setupNavigationBar(with: config)
 
 // 8️⃣ إخفاء شريط التنقل
 hideNavigationBar()
 
 // 9️⃣ إعداد زر مخصص
 setNavigationRightButton(type: .custom(icon: "person.circle", title: "Profile")) {
     goToProfile()
 }
 
 // 🔟 إعداد متقدم مع عدة أزرار
 let advancedConfig = NavigationConfig(
     title: "تفاصيل الرسالة",
     leftButton: NavigationButton(type: .back),
     rightButton: NavigationButton(type: .more, badge: "3"),
     backgroundColor: .secondBackground,
     titleColor: .text,
     tintColor: .accent
 )
 setupNavigationBar(with: advancedConfig)
 
 */
