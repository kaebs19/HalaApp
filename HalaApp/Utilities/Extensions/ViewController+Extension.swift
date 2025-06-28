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
    
    /// تطبيق التجاوب البسيط على الشاشة كاملة
    func makeResponsive() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            // تحسين المسافات العامة أولاً
            adaptSpacingForIPad()
            
            // تطبيق على جميع Labels مع تحسينات
            view.getAllSubviews(ofType: UILabel.self).forEach { label in
                if let currentFont = label.font {
                    let currentSize = currentFont.pointSize
                    let newSize: CGFloat
                    
                    // قاعدة محسّنة للنصوص
                    if currentSize <= 12 {
                        newSize = currentSize + 4
                    } else if currentSize <= 16 {
                        newSize = currentSize + 2
                    } else if currentSize <= 24 {
                        newSize = min(currentSize * 1.2, 32) // حد أقصى للعناوين
                    } else {
                        newSize = min(currentSize * 1.1, 40) // حد أقصى للعناوين الكبيرة
                    }
                    
                    label.font = currentFont.withSize(newSize)
                    
                    // تحسين قابلية القراءة للنصوص الطويلة
                    if currentSize >= 16 {
                        label.preferredMaxLayoutWidth = view.frame.width * 0.75
                        label.lineBreakMode = .byWordWrapping
                    }
                }
            }
            
            // تحسين الأزرار
            view.getAllSubviews(ofType: UIButton.self).forEach { button in
                if let currentFont = button.titleLabel?.font {
                    let currentSize = currentFont.pointSize
                    let newSize: CGFloat
                    
                    if currentSize <= 12 {
                        newSize = currentSize + 5
                    } else if currentSize <= 16 {
                        newSize = currentSize + 3
                    } else {
                        newSize = currentSize * 1.1
                    }
                    
                    button.titleLabel?.font = currentFont.withSize(newSize)
                    
                    // زيادة منطقة اللمس للأزرار
                    button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
                }
            }
            
            // تحسين TextFields
            view.getAllSubviews(ofType: UITextField.self).forEach { textField in
                if let currentFont = textField.font {
                    let currentSize = currentFont.pointSize
                    let newSize: CGFloat
                    
                    if currentSize <= 12 {
                        newSize = currentSize + 5
                    } else if currentSize <= 16 {
                        newSize = currentSize + 3
                    } else {
                        newSize = currentSize * 1.1
                    }
                    
                    textField.font = currentFont.withSize(newSize)
                }
            }
            
            // تحسين الصور
            adaptImagesForIPad()
        }
    }

    // دالة مساعدة للمسافات
    private func adaptSpacingForIPad() {
        // زيادة المسافات للـ StackViews
        view.getAllSubviews(ofType: UIStackView.self).forEach { stackView in
            stackView.spacing = max(stackView.spacing * 1.4, 16)
        }
        
        // تحسين الهوامش للـ Container
        view.layoutMargins = UIEdgeInsets(
            top: view.layoutMargins.top + 20,
            left: max(view.layoutMargins.left * 1.5, 40),
            bottom: view.layoutMargins.bottom + 20,
            right: max(view.layoutMargins.right * 1.5, 40)
        )
    }

    // دالة مساعدة للصور
    private func adaptImagesForIPad() {
        view.getAllSubviews(ofType: UIImageView.self).forEach { imageView in
            // تحديد حد أقصى معقول للصور
            if imageView.frame.width > 200 || imageView.frame.height > 200 {
                imageView.contentMode = .scaleAspectFit
                
                // إضافة قيود إذا لم تكن موجودة
                if imageView.constraints.isEmpty {
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 450),
                        imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 450)
                    ])
                }
            }
        }
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

