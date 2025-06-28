//
//  NavigationBarManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 20/06/2025.
//

import UIKit

// MARK: - Navigation Bar Manager
class NavigationBarManager {
    
    // MARK: - Properties
    internal weak var viewController: UIViewController?
    private var currentConfig: NavigationConfig?
    
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
        config.leftButton = NavigationButton(type: .back(), action: action ?? handleBackButton)
        configure(with: config)
    }
    
    /// إعداد سريع لزر الإغلاق
    func setCloseButton(action: (() -> Void)? = nil) {
        var config = currentConfig ?? .default
        config.leftButton = NavigationButton(type: .close(), action: action ?? handleCloseButton)
        configure(with: config)
    }
    
    /// إعداد سريع لزر في الجهة اليمنى
    func setRightButton(type: NavigationButtonType, action: @escaping () -> Void) {
        var config = currentConfig ?? .default
        config.rightButton = NavigationButton(type: type, action: action)
        configure(with: config)
    }
    
    /// إعداد أزرار متعددة مع دعم تغيير الاتجاه حسب اللغة
    func setMultipleButtons(
        items: [NavigationButtonType],
        title: Title? = nil,
        isLargeTitle: Bool = false,
        actions: [NavigationButtonType: () -> Void] = [:]
    ) {
        var config = currentConfig ?? .default
        
        // إعداد العنوان
        if let title = title {
            config.title = title.TextTitle
            config.isLargeTitleEnabled = isLargeTitle
        }
        
        var leftButtons: [NavigationButton] = []
        var rightButtons: [NavigationButton] = []
        
        // تصنيف الأزرار حسب النوع
        for item in items {
            let action = actions[item] ?? getDefaultAction(for: item)
            let button = NavigationButton(type: item, action: action)
            
            // تحديد موقع الزر حسب نوعه
            if item.defaultPosition == .left {
                leftButtons.append(button)
            } else {
                rightButtons.append(button)
            }
        }
        
        // تطبيق الأزرار مع مراعاة اللغة
        applyMultipleButtons(
            config: &config,
            leftButtons: leftButtons,
            rightButtons: rightButtons
        )
        
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
        
        // إعداد الأزرار المتعددة أولاً إذا وجدت
        let hasLeftButtons = config.leftButtons?.isEmpty == false
        let hasRightButtons = config.rightButtons?.isEmpty == false
        
        if hasLeftButtons || hasRightButtons {
            setupMultipleButtons(config: config)
            return
        }
        
        // إعداد الزر الأيسر/الأيمن حسب اللغة (للأزرار المفردة)
        let isRTL = !LanguageManager.shared.isEnglish()
        
        if isRTL {
            // في العربية: الزر الأساسي على اليمين
            if let leftButton = config.leftButton {
                vc.navigationItem.rightBarButtonItem = createBarButtonItem(from: leftButton)
            } else {
                vc.navigationItem.rightBarButtonItem = nil
            }
            
            if let rightButton = config.rightButton {
                vc.navigationItem.leftBarButtonItem = createBarButtonItem(from: rightButton)
            } else {
                vc.navigationItem.leftBarButtonItem = nil
            }
        } else {
            // في الإنجليزية: الترتيب العادي
            if let leftButton = config.leftButton {
                vc.navigationItem.leftBarButtonItem = createBarButtonItem(from: leftButton)
            } else {
                vc.navigationItem.leftBarButtonItem = nil
            }
            
            if let rightButton = config.rightButton {
                vc.navigationItem.rightBarButtonItem = createBarButtonItem(from: rightButton)
            } else {
                vc.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    /// إعداد الأزرار المتعددة
    private func setupMultipleButtons(config: NavigationConfig) {
        guard let vc = viewController else { return }
        
        let isRTL = !LanguageManager.shared.isEnglish()
        
        // تحويل الأزرار إلى UIBarButtonItem
        let leftBarButtons = (config.leftButtons ?? []).compactMap { createBarButtonItem(from: $0) }
        let rightBarButtons = (config.rightButtons ?? []).compactMap { createBarButtonItem(from: $0) }
        
        if isRTL {
            // في العربية: عكس المواقع
            vc.navigationItem.leftBarButtonItems = rightBarButtons
            vc.navigationItem.rightBarButtonItems = leftBarButtons
        } else {
            // في الإنجليزية: الترتيب العادي
            vc.navigationItem.leftBarButtonItems = leftBarButtons
            vc.navigationItem.rightBarButtonItems = rightBarButtons
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
            // اختيار مصدر الصورة (Assets أم النظام)
            let image = getThemedImage(for: button.type)

            
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
    
    // أضف هذه الدالة في NavigationBarManager
    private func getThemedImage(for buttonType: NavigationButtonType) -> UIImage? {
        let size: CGFloat = 24
        
        // الأيقونات المخصصة من Assets مع دعم الثيم
        if !buttonType.isSystemIcon {
            switch buttonType {
            case .close:
                return ImageManager.image(.close)?.resized(to: CGSize(width: size, height: size))
            case .menu:
                return ImageManager.image(.menu)?.resized(to: CGSize(width: size, height: size))
            case .more:
                return ImageManager.image(.morefill)?.resized(to: CGSize(width: size, height: size))
            case .save:
                return ImageManager.image(.save)?.resized(to: CGSize(width: size, height: size))
            case .notificaiton:
                return ImageManager.image(.notification)?.resized(to: CGSize(width: size, height: size))
            case .search:
                return ImageManager.image(.search)?.resized(to: CGSize(width: size, height: size))
            case .back:
                return ImageManager.image(.back)?.resized(to: CGSize(width: size, height: size))
            default:
                break
            }
        }
        
        // أيقونات النظام مع لون الثيم
        let systemImage = UIImage(systemName: buttonType.iconName)?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: size))
        
        // تطبيق لون حسب الثيم
        let themeColor = getThemeBasedTintColor()
        return systemImage?.withTintColor(themeColor.color, renderingMode: .alwaysOriginal)
    }

    // دالة مساعدة للحصول على لون الثيم
    private func getThemeBasedTintColor() -> AppColors {
        let isDark = ThemeManager.shared.isDarkModeActive
        return isDark ? .textSecondary : .primary
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
        navigationBar.tintColor = config.tintColor.color
    }
    
    private func addBadge(to barButtonItem: UIBarButtonItem, text: String) {
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
    
    // MARK: - Multiple Buttons Helper Methods
    
    /// تطبيق الأزرار المتعددة مع مراعاة اتجاه اللغة
    private func applyMultipleButtons(
        config: inout NavigationConfig,
        leftButtons: [NavigationButton],
        rightButtons: [NavigationButton]
    ) {
        // في العربية نعكس المواقع
        let isRTL = !LanguageManager.shared.isEnglish()
        
        if isRTL {
            // في العربية: الأزرار الأساسية (رجوع/قائمة) على اليمين
            config.rightButtons = leftButtons
            config.leftButtons = rightButtons
        } else {
            // في الإنجليزية: الترتيب العادي
            config.leftButtons = leftButtons
            config.rightButtons = rightButtons
        }
    }
}

// MARK: - Associated Keys
private struct AssociatedKeys {
    static var buttonAction = "buttonAction"
    static var navigationManager = "navigationManager"
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
    
    /// إعداد أزرار متعددة مع دعم اللغة والاتجاه (مُبسط)
    func setNavigationButtons(
        items: [NavigationButtonType],
        title: Title? = nil,
        isLargeTitle: Bool = false,
        actions: [NavigationButtonType: () -> Void] = [:]
    ) {
        navigationManager.setMultipleButtons(
            items: items,
            title: title,
            isLargeTitle: isLargeTitle,
            actions: actions
        )
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

// MARK: - Quick Setup Examples
/*
 
 📱 أمثلة الاستخدام المُبسطة:
 ==========================
 
 // 1️⃣ إعداد بسيط للعنوان فقط
 setNavigationTitle(.settings)
 
 // 2️⃣ إعداد عنوان كبير
 setNavigationTitle(.home, isLarge: true)
 
 // 3️⃣ إعداد زر رجوع + زر حفظ (بدون actions - ستستخدم الافتراضية)
 setNavigationButtons(items: [.back, .save], title: .settings)
 
 // 4️⃣ إعداد زر رجوع + زر حفظ (مع actions مخصصة)
 setNavigationButtons(
     items: [.back, .save],
     title: .settings,
     actions: [
         .save: { [weak self] in
             self?.saveSettings()
         }
     ]
 )
 
 // 5️⃣ إعداد قائمة + بحث + إشعارات (افتراضية)
 setNavigationButtons(items: [.menu, .search, .notificaiton], title: .home, isLargeTitle: true)
 
 // 6️⃣ إعداد إغلاق + التالي (افتراضية)
 setNavigationButtons(items: [.close, .next])
 
 // 7️⃣ إعداد زر مخصص
 setNavigationButtons(
     items: [.back, .custom(icon: "person.circle", title: "Profile")],
     actions: [
         .custom(icon: "person.circle", title: "Profile"): { [weak self] in
             self?.showProfile()
         }
     ]
 )
 
 // 8️⃣ إعداد متقدم مع عدة أزرار وإجراءات مختلطة
 setNavigationButtons(
     items: [.menu, .save, .more, .notificaiton],
     title: .dashboard,
     actions: [
         .save: { [weak self] in
             self?.saveData()
         },
         .more: { [weak self] in
             self?.showCustomMoreOptions()
         }
         // .menu و .notificaiton ستستخدم الإجراءات الافتراضية
     ]
 )
 
 */
