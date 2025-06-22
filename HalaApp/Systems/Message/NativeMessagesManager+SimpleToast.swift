//
//  NativeMessagesManager+SimpleToast.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - Simple Toast Configuration
struct SimpleToastConfiguration {
    var duration: TimeInterval = 2.0
    var backgroundColor: AppColors = .background
    var textColor: AppColors = .text
    var cornerRadius: CGFloat = 12
    var shadowOpacity: Float = 0.1
    var animationDuration: TimeInterval = 0.3
    var position: ToastPosition = .top
    
    static let `default` = SimpleToastConfiguration()
}

enum ToastPosition {
    case top
    case center
    case bottom
}

// MARK: - Simple Toast Extension
extension NativeMessagesManager {
    
    // MARK: - Simple Toast Methods (بدون خلفية معتمة)
    
    /// عرض تنبيه بسيط بدون خلفية معتمة
    func showSimpleToast(
        title: String,
        message: String = "",
        type: SimpleToastType = .info,
        configuration: SimpleToastConfiguration = .default
    ) {
        DispatchQueue.main.async {
            self.hideCurrentToast()
            self.createAndShowSimpleToast(
                title: title,
                message: message,
                type: type,
                configuration: configuration
            )
        }
    }
    
    // MARK: - Quick Toast Methods
    
    /// تنبيه نجاح بسيط
    func showSimpleSuccess(_ title: String, message: String = "") {
        showSimpleToast(title: title, message: message, type: .success)
    }
    
    /// تنبيه خطأ بسيط
    func showSimpleError(_ title: String, message: String = "") {
        showSimpleToast(title: title, message: message, type: .error)
    }
    
    /// تنبيه تحذير بسيط
    func showSimpleWarning(_ title: String, message: String = "") {
        showSimpleToast(title: title, message: message, type: .warning)
    }
    
    /// تنبيه معلومات بسيط
    func showSimpleInfo(_ title: String, message: String = "") {
        showSimpleToast(title: title, message: message, type: .info)
    }
    
    /// تنبيه تحميل بسيط (يختفي تلقائياً)
    func showSimpleLoading(_ title: String, duration: TimeInterval = 2.0) {
        var config = SimpleToastConfiguration.default
        config.duration = duration
        showSimpleToast(title: title, type: .loading, configuration: config)
    }
    
    // MARK: - Social Login Toast
    
    /// تنبيه تسجيل الدخول الاجتماعي
    func showSocialLoginToast(provider: String) {
        showSimpleLoading("تسجيل الدخول بـ \(provider)", duration: 2.0)
        
        // بعد انتهاء التحميل، عرض رسالة المعلومات
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.showSimpleInfo("قريباً", message: "تسجيل الدخول بـ \(provider) متاح قريباً")
        }
    }
    
    // MARK: - Private Implementation
    
    private var currentToastView: UIView? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.currentToast) as? UIView }
        set { objc_setAssociatedObject(self, &AssociatedKeys.currentToast, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private func hideCurrentToast() {
        currentToastView?.removeFromSuperview()
        currentToastView = nil
    }
    
    private func createAndShowSimpleToast(
        title: String,
        message: String,
        type: SimpleToastType,
        configuration: SimpleToastConfiguration
    ) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let toastView = createToastView(
            title: title,
            message: message,
            type: type,
            configuration: configuration
        )
        
        currentToastView = toastView
        window.addSubview(toastView)
        
        // تحديد موضع التنبيه
        setupToastConstraints(toastView: toastView, position: configuration.position, in: window)
        
        // تأثير الظهور
        toastView.alpha = 0
        toastView.transform = CGAffineTransform(translationX: 0, y: -50)
        
        UIView.animate(
            withDuration: configuration.animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            toastView.alpha = 1
            toastView.transform = .identity
        }
        
        // الإخفاء التلقائي
        DispatchQueue.main.asyncAfter(deadline: .now() + configuration.duration) {
            self.hideToastWithAnimation(toastView, configuration: configuration)
        }
    }
    
    private func createToastView(
        title: String,
        message: String,
        type: SimpleToastType,
        configuration: SimpleToastConfiguration
    ) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = configuration.backgroundColor.color
        containerView.layer.cornerRadius = configuration.cornerRadius
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = configuration.shadowOpacity
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // أيقونة التنبيه
        let iconImageView = UIImageView()
        iconImageView.image = type.icon
        iconImageView.tintColor = type.color
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // العنوان
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: Sizes.size_16.rawValue,
                                      weight: FontStyle.regular.uiFontWeight)
        titleLabel.textColor = configuration.textColor.color
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // الرسالة (إذا وجدت)
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = .systemFont(ofSize: Sizes.size_14.rawValue,
                                        weight: FontStyle.regular.uiFontWeight)
        messageLabel.textColor = configuration.textColor.color
        messageLabel.numberOfLines = 2
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.isHidden = message.isEmpty
        
        // ترتيب العناصر
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            // أيقونة
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // العنوان
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: message.isEmpty ? 16 : 12),
            
            // الرسالة
            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            // ارتفاع الحاوية
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: message.isEmpty ? 56 : 72)
        ])
        
        return containerView
    }
    
    private func setupToastConstraints(toastView: UIView, position: ToastPosition, in window: UIWindow) {
        let safeArea = window.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
            toastView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20)
        ])
        
        switch position {
        case .top:
            toastView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
        case .center:
            toastView.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        case .bottom:
            toastView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16).isActive = true
        }
    }
    
    private func hideToastWithAnimation(_ toastView: UIView, configuration: SimpleToastConfiguration) {
        UIView.animate(
            withDuration: configuration.animationDuration,
            animations: {
                toastView.alpha = 0
                toastView.transform = CGAffineTransform(translationX: 0, y: -30)
            }
        ) { _ in
            toastView.removeFromSuperview()
            if self.currentToastView == toastView {
                self.currentToastView = nil
            }
        }
    }
}

// MARK: - Simple Toast Types
enum SimpleToastType {
    case success
    case error
    case warning
    case info
    case loading
    
    var icon: UIImage? {
        switch self {
        case .success:
            return UIImage(systemName: "checkmark.circle.fill")
        case .error:
            return UIImage(systemName: "xmark.circle.fill")
        case .warning:
            return UIImage(systemName: "exclamationmark.triangle.fill")
        case .info:
            return UIImage(systemName: "info.circle.fill")
        case .loading:
            return UIImage(systemName: "arrow.clockwise.circle.fill")
        }
    }
    
    var color: UIColor {
        switch self {
        case .success:
            return .systemGreen
        case .error:
            return .systemRed
        case .warning:
            return .systemOrange
        case .info:
            return .systemBlue
        case .loading:
            return .systemGray
        }
    }
}

// MARK: - Associated Keys
private struct AssociatedKeys {
    static var currentToast = "currentToast"
}

// MARK: - Updated Social Login Handler
extension NativeMessagesManager {
    /// معالج تسجيل الدخول الاجتماعي المحدث
    func handleSocialLogin(provider: String) {
        showSocialLoginToast(provider: provider)
    }
}
