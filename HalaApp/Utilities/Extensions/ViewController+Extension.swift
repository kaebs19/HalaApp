    //
    //  ViewController+Extension.swift
    //  HalaApp
    //
    //  Created by Mohammed Saleh on 08/06/2025.
    //

    import UIKit


    extension UIViewController {
        
        enum NavigationStyle {
            case push
            case present(animated: Bool = true, completion: (() -> Void)? = nil)
        }

        /// الانتقال لواجهة جديدة مع خيارات متقدمة
        func goToVC(
            storyboard: Storyboards = .Main,
            identifiers: Identifiers,
            navigationStyle: NavigationStyle = .push,
            animationOptions: UIView.AnimationOptions = .transitionCrossDissolve,
            duration: TimeInterval = 0.3,
            configure: ((UIViewController) -> Void)? = nil
        ) {
            let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: identifiers.rawValue)
            
            configure?(vc)
            
            switch navigationStyle {
            case .push:
                guard let navigationController = navigationController else {
                    print("❌ Error: No navigation controller found")
                    return
                }
                
                UIView.transition(
                    with: navigationController.view,
                    duration: duration,
                    options: animationOptions,
                    animations: {
                        navigationController.pushViewController(vc, animated: false)
                    }
                )
                
            case .present(let animated, let completion):
                present(vc, animated: animated, completion: completion)
            }
        }
        
        /// إظهار شريط التنقل
        func showNavigationBar(animated: Bool = true) {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
        /// إخفاء شريط التنقل
        func hideNavigationBar(animated: Bool = true) {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        
        /// الرجوع للواجهة السابقة
        func popViewController(animated: Bool = true) {
            navigationController?.popViewController(animated: animated)
        }
        
        /// الرجوع للواجهة الرئيسية
        func popToRootViewController(animated: Bool = true) {
            navigationController?.popToRootViewController(animated: animated)
        }
        
        /// إغلاق الواجهة المعروضة
        func dismissViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
            dismiss(animated: animated, completion: completion)
        }
        
        /// إخفاء شريط التبويب
        func hideOrShowTabBar(isHidden: Bool = true) {
            tabBarController?.tabBar.isHidden = isHidden
        }
        
        /// إخفاء زر الرجوع
        func hideBackButton(isHidden: Bool = true) {
            navigationItem.hidesBackButton = isHidden
            if isHidden {
                navigationItem.leftBarButtonItems = nil
            }
        }
        
        /// تعيين زر رجوع فارغ
        func setEmptyBackButton() {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }

        
    }


extension UIViewController {
    
    /// إعداد مراقب الثيم في ViewController
    func setupThemeObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChange),
            name: .themeDidChange,
            object: nil
        )
    }
    
    /// إزالة مراقب الثيم
    func removeThemeObserver() {
        NotificationCenter.default.removeObserver(self, name: .themeDidChange, object: nil)
    }
    
    /// استجابة لتغيير الثيم (يجب override في الـ ViewControllers)
    @objc func themeDidChange() {
        // يمكن للـ ViewControllers تنفيذ هذه الدالة لتحديث الواجهة
        updateUIForCurrentTheme()
    }
    
    /// تحديث الواجهة حسب الثيم الحالي
    @objc func updateUIForCurrentTheme() {
        // دالة افتراضية - يمكن override في الـ ViewControllers
        view.setBackgroundColor(.background)
    }
   
}
