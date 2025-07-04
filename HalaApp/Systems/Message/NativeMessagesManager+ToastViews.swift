//
//  NativeMessagesManager+ToastViews.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - Toast & Special Views Creation (إنشاء واجهات Toast والواجهات الخاصة)
extension NativeMessagesManager {
    
    // MARK: - Progress Views
    /// إنشاء واجهة شريط التقدم
    /// - Parameters:
    ///   - title: عنوان العملية
    ///   - progress: نسبة التقدم
    ///   - animated: تفعيل الحركة
    /// - Returns: واجهة شريط التقدم
    func createProgressView(title: String, progress: Float, animated: Bool) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemBlue
        containerView.layer.cornerRadius = DefaultSettings.cornerRadius
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = DefaultSettings.shadowOpacity
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = FontManager.shared.fontApp(family: .cairo, style: .bold, size: .size_16)
        titleLabel.textAlignment = .center
        
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.tag = 999 // للوصول السهل
        progressBar.progressTintColor = .white
        progressBar.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progressBar.setProgress(progress, animated: animated)
        
        let progressLabel = UILabel()
        progressLabel.tag = 998 // للوصول السهل
        progressLabel.text = "\(Int(progress * 100))%"
        progressLabel.textColor = .white
        progressLabel.font = FontManager.shared.fontApp(family: .cairo, style: .medium, size: .size_14)
        progressLabel.textAlignment = .center
        
        [titleLabel, progressBar, progressLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            progressLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8),
            progressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            progressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            progressLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        return containerView
    }
    
    // MARK: - Toast Views
    /// إنشاء Toast بسيط
    /// - Parameter message: نص الرسالة
    /// - Returns: واجهة Toast
    func createToastView(message: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        containerView.layer.cornerRadius = 20
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = FontManager.shared.fontApp(family: .cairo, style: .medium, size: .size_14)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        containerView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        return containerView
    }
    
    /// إنشاء Toast محسن مع تأثيرات بصرية
    /// - Parameter message: نص الرسالة
    /// - Returns: واجهة Toast محسنة
    func createEnhancedToastView(message: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        containerView.layer.cornerRadius = 25
        
        // إضافة تأثير ضبابي (blur effect)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        containerView.addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = FontManager.shared.fontApp(family: .cairo, style: .medium, size: .size_15)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        containerView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // تأثير الضباب
            blurEffectView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // نص الرسالة
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14)
        ])
        
        return containerView
    }
    
    /// إنشاء Toast مع أيقونة
    /// - Parameters:
    ///   - message: نص الرسالة
    ///   - icon: الأيقونة
    /// - Returns: واجهة Toast مع أيقونة
    func createToastWithIconView(message: String, icon: UIImage?) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        containerView.layer.cornerRadius = 25
        
        // أيقونة
        let iconImageView = UIImageView()
        if let icon = icon {
            iconImageView.image = icon
            iconImageView.tintColor = .white
            iconImageView.contentMode = .scaleAspectFit
        }
        
        // نص
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = FontManager.shared.fontApp(family: .cairo, style: .medium, size: .size_15)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        // Stack view
        let stackView = UIStackView(arrangedSubviews: [iconImageView, messageLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // حجم الأيقونة
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Stack view
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14)
        ])
        
        return containerView
    }
    
    // MARK: - Notification Views
    /// إنشاء واجهة الإشعار
    /// - Parameters:
    ///   - title: عنوان الإشعار
    ///   - message: نص الإشعار
    ///   - icon: أيقونة الإشعار
    ///   - actionTitle: نص زر الإجراء
    ///   - action: إجراء الزر
    /// - Returns: واجهة الإشعار
    func createNotificationView(
        title: String,
        message: String,
        icon: UIImage?,
        actionTitle: String?,
        action: (() -> Void)?
    ) -> UIView {
        
        let containerView = UIView()
        containerView.backgroundColor = AppColors.secondBackground.color
        containerView.layer.cornerRadius = DefaultSettings.cornerRadius
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = DefaultSettings.shadowOpacity
        
        let iconImageView = UIImageView()
        if let icon = icon {
            iconImageView.image = icon
            iconImageView.tintColor = AppColors.primary.color
            iconImageView.contentMode = .scaleAspectFit
        }
        
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 4
        contentStackView.alignment = .leading
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = AppColors.text.color
        titleLabel.font = FontManager.shared.fontApp(family: .cairo, style: .bold, size: .size_16)
        titleLabel.numberOfLines = 1
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = AppColors.text.color
        messageLabel.font = FontManager.shared.fontApp(family: .cairo, style: .regular, size: .size_14)
        messageLabel.numberOfLines = 2
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(messageLabel)
        
        var arrangedSubviews: [UIView] = [iconImageView, contentStackView]
        
        if let actionTitle = actionTitle, let action = action {
            let button = UIButton(type: .system)
            button.setTitle(actionTitle, for: .normal)
            button.setTitleColor(AppColors.primary.color, for: .normal)
            button.titleLabel?.font = FontManager.shared.fontApp(family: .cairo, style: .semiBold, size: .size_14)
            
            if #available(iOS 14.0, *) {
                button.addAction(UIAction { _ in
                    self.hideCurrentMessage()
                    action()
                }, for: .touchUpInside)
            } else {
                // Fallback للإصدارات الأقدم
            }
            
            arrangedSubviews.append(button)
        }
        
        let mainStackView = UIStackView(arrangedSubviews: arrangedSubviews)
        mainStackView.axis = .horizontal
        mainStackView.spacing = 12
        mainStackView.alignment = .center
        
        containerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        return containerView
    }
    
    // MARK: - Action Message Views
    /// إنشاء واجهة رسالة الإجراءات المتعددة
    /// - Parameters:
    ///   - title: عنوان الرسالة
    ///   - message: نص الرسالة
    ///   - actions: قائمة الإجراءات
    /// - Returns: واجهة رسالة الإجراءات
    func createActionMessageView(
        title: String,
        message: String,
        actions: [(title: String, style: UIAlertAction.Style, handler: () -> Void)]
    ) -> UIView {
        
        let containerView = UIView()
        containerView.backgroundColor = AppColors.secondBackground.color
        containerView.layer.cornerRadius = DefaultSettings.cornerRadius
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        containerView.layer.shadowRadius = 16
        containerView.layer.shadowOpacity = 0.4
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = FontManager.shared.fontApp(family: .cairo, style: .bold, size: .size_18)
        titleLabel.textColor = AppColors.text.color
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = FontManager.shared.fontApp(family: .cairo, style: .medium, size: .size_15)
        messageLabel.textColor = AppColors.textSecondary.color
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        let actionsStackView = UIStackView()
        actionsStackView.axis = .vertical
        actionsStackView.spacing = 8
        actionsStackView.distribution = .fillEqually
        
        for actionData in actions {
            let button = createActionButton(
                title: actionData.title,
                style: actionData.style,
                handler: actionData.handler
            )
            actionsStackView.addArrangedSubview(button)
        }
        
        [titleLabel, messageLabel, actionsStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: min(UIScreen.main.bounds.width - 40, 320)),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            actionsStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            actionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            actionsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            actionsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            actionsStackView.heightAnchor.constraint(equalToConstant: CGFloat(actions.count * 44 + (actions.count - 1) * 8))
        ])
        
        return containerView
    }
    
    /// إنشاء زر للإجراءات
    /// - Parameters:
    ///   - title: نص الزر
    ///   - style: نمط الزر
    ///   - handler: معالج الإجراء
    /// - Returns: الزر
    func createActionButton(
        title: String,
        style: UIAlertAction.Style,
        handler: @escaping () -> Void
    ) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = FontManager.shared.fontApp(family: .cairo, style: .semiBold, size: .size_16)
        button.layer.cornerRadius = 8
        
        switch style {
        case .default:
            button.backgroundColor = AppColors.primary.color
            button.setTitleColor(AppColors.buttonText.color, for: .normal)
        case .destructive:
            button.backgroundColor = UIColor.systemRed
            button.setTitleColor(.white, for: .normal)
        case .cancel:
            button.backgroundColor = AppColors.boarderColor.color
            button.setTitleColor(AppColors.text.color, for: .normal)
        @unknown default:
            button.backgroundColor = AppColors.primary.color
            button.setTitleColor(AppColors.buttonText.color, for: .normal)
        }
        
        if #available(iOS 14.0, *) {
            button.addAction(UIAction { _ in
                if let hapticManager = HapticManager.shared as? HapticManager {
                    hapticManager.lightImpact()
                }
                self.hideCurrentMessage()
                handler()
            }, for: .touchUpInside)
        } else {
            // Fallback للإصدارات الأقدم
        }
        
        return button
    }
}
