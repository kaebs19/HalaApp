//
//  AppNavigationManager+Core.swift
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

//
//  MainTabBars.swift
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

class MainTabBars: UITabBarController {
    
    // MARK: - Properties
    private var selectedIndexs: Int = 0
    private var indicatorView: UIView?
    private var indicatorConstraints: [NSLayoutConstraint] = []
    private var themeObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // إعداد TabBar
        setupTabBar()
        
        // إعداد مراقب الثيم
        setupThemeObserver()
        
        // تطبيق الثيم الحالي
        updateUIForCurrentTheme()
        
        // تعيين delegate
        self.delegate = self
        
        print("✅ Main TabBar Controller تم تحميله بنجاح")
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let indicatorView = indicatorView {
            updateIndicatorPosition(forSelectedIndex: selectedIndexs, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupTabBar() // إعادة تحميل التبويبات
    }
    
    
    deinit {
        removeThemeObserver()
    }
}

// MARK: - Setup
extension MainTabBars {
    
    private func setupTabBar() {
        // إعداد عناصر TabBar
        setupTabBarItems()
        
        // تخصيص المظهر
        customizeTabBarAppearance()
        
        // إضافة المؤشر المتحرك
        setupMovingIndicator()
        
        // إضافة الظل
        setupTabBarShadow()
        
        // تعيين التبويب الافتراضي
        selectedIndex = 0
        updateIndicatorPosition(forSelectedIndex: 0, animated: false)
        
        // تحديث العناوين
        updateTabBarItemTitles(selectedIndex: 0)
    }
    
    private func setupTabBarItems() {
        guard let viewControllers = self.viewControllers,
              viewControllers.count >= 4 else {
            print("❌ عدد ViewControllers غير كافي")
            return
        }
        
        let configs = [
            TabBarItemConfig(
                title: .Home,
                selectedImage: ImageManager.image(.homeSelected) ?? UIImage(systemName: "house.fill")!,
                unselectedImage: ImageManager.image(.homeUnselected) ?? UIImage(systemName: "house")!
            ),
            TabBarItemConfig(
                title: .Messages,
                selectedImage: ImageManager.image(.messageSelected) ?? UIImage(systemName: "message.fill")!,
                unselectedImage: ImageManager.image(.messageUnselected) ?? UIImage(systemName: "message")!
            ),
            TabBarItemConfig(
                title: .Notifications,
                selectedImage: ImageManager.image(.notificationSelected) ?? UIImage(systemName: "bell.fill")!,
                unselectedImage: ImageManager.image(.notificationUnselected) ?? UIImage(systemName: "bell")!
            ),
            TabBarItemConfig(
                title: .Account,
                selectedImage: ImageManager.image(.accountSelected) ?? UIImage(systemName: "person.fill")!,
                unselectedImage: ImageManager.image(.accountUnselected) ?? UIImage(systemName: "person")!
            )
        ]
        
        for (index, viewController) in viewControllers.enumerated() {
            if index < configs.count {
                let config = configs[index]
                
                // إنشاء TabBarItem جديد
                let tabBarItem = UITabBarItem(
                    title: "",
                    image: config.unselectedImage.withRenderingMode(.alwaysOriginal),
                    selectedImage: config.selectedImage.withRenderingMode(.alwaysTemplate)
                )
                
                tabBarItem.accessibilityLabel = config.title.titleName
                viewController.tabBarItem = tabBarItem
                
                print("✅ تم تكوين TabBarItem: \(config.title.titleName)")
            }
        }
    }
}

// MARK: - Appearance
extension MainTabBars {
    
    private func customizeTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.tabBar.color
        appearance.shadowColor = AppColors.separator.color.withAlphaComponent(0.3)
        
        let itemAppearance = UITabBarItemAppearance()
        
        // تحديد ألوان النص
        itemAppearance.normal.titleTextAttributes = [
            .font: FontManager.shared.font(size: .size_10),
            .foregroundColor: AppColors.text.color
        ]
        
        itemAppearance.selected.titleTextAttributes = [
            .font: FontManager.shared.boldFont(size: .size_10),
            .foregroundColor: AppColors.primary.color
        ]
        
        itemAppearance.normal.iconColor = AppColors.textSecondary.color
        itemAppearance.selected.iconColor = AppColors.primary.color
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = AppColors.primary.color
        tabBar.unselectedItemTintColor = AppColors.textSecondary.color
    }
    
    private func setupTabBarShadow() {
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowOpacity = 0.1
    }
}

// MARK: - Moving Indicator
extension MainTabBars {
    
    private func setupMovingIndicator() {
        let indicator = UIView()
        indicator.backgroundColor = AppColors.primary.color
        indicator.layer.cornerRadius = 2
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        tabBar.addSubview(indicator)
        self.indicatorView = indicator
    }
    
    private func updateIndicatorPosition(forSelectedIndex index: Int, animated: Bool) {
        guard let indicatorView = indicatorView,
              let items = tabBar.items,
              index < items.count else { return }
        
        let tabWidth = tabBar.bounds.width / CGFloat(items.count)
        let indicatorWidth = tabWidth / 2
        let indicatorX = tabWidth * CGFloat(index) + (tabWidth - indicatorWidth) / 2
        
        NSLayoutConstraint.deactivate(indicatorConstraints)
        
        indicatorConstraints = [
            indicatorView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 4),
            indicatorView.widthAnchor.constraint(equalToConstant: indicatorWidth),
            indicatorView.heightAnchor.constraint(equalToConstant: 4),
            indicatorView.centerXAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: indicatorX + indicatorWidth / 2)
        ]
        
        NSLayoutConstraint.activate(indicatorConstraints)
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
            view.layoutIfNeeded()
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabBars: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return }
        
        selectedIndexs = index
        updateIndicatorPosition(forSelectedIndex: index, animated: true)
        applyPulseEffect(at: index)
        updateTabBarItemTitles(selectedIndex: index)
    }
    
    private func applyPulseEffect(at index: Int) {
        let tabBarButtons = tabBar.subviews.compactMap { view -> UIView? in
            if String(describing: type(of: view)).contains("UITabBarButton") {
                return view
            }
            return nil
        }
        
        guard index < tabBarButtons.count else { return }
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.fromValue = 1.0
        pulse.toValue = 1.1
        pulse.duration = 0.3
        pulse.autoreverses = true
        
        tabBarButtons[index].layer.add(pulse, forKey: "pulse")
    }
    
    private func updateTabBarItemTitles(selectedIndex: Int) {
        guard let items = tabBar.items else { return }
        
        for (index, item) in items.enumerated() {
            item.title = (index == selectedIndex) ? item.accessibilityLabel : ""
        }
    }
}

// MARK: - Theme Support
extension MainTabBars {
    
    override func updateUIForCurrentTheme() {
        // تحديث الألوان حسب الثيم
        customizeTabBarAppearance()
        indicatorView?.backgroundColor = AppColors.primary.color
        
        // تحديث الخلفية
        view.backgroundColor = AppColors.background.color
    }
}

// MARK: - Supporting Types
struct TabBarItemConfig {
    let title: TitleBar
    let selectedImage: UIImage
    let unselectedImage: UIImage
}

enum TitleBar: String, CaseIterable {
    case Home = "HomeTitle"
    case Messages = "MessagesTitle"
    case Notifications = "NotificationsTitle"
    case Account = "AccountTitle"
    
    var titleName: String {
        return self.rawValue.localized
    }
}
