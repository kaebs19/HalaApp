//
//  NativeMessagesManager+Views.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - View Creation Methods (طرق إنشاء الواجهات)
extension NativeMessagesManager {
    
    /// إنشاء واجهة الرسالة الأساسية
    /// - Parameters:
    ///   - title: عنوان الرسالة
    ///   - message: نص الرسالة
    ///   - type: نوع الرسالة
    ///   - configuration: إعدادات العرض
    /// - Returns: واجهة الرسالة
    func createMessageView(title: String, message: String, type: MessageType, configuration: MessageConfiguration) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = type.backgroundColor
        containerView.layer.cornerRadius = DefaultSettings.cornerRadius
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = DefaultSettings.shadowOpacity
        
        // Icon
        let iconImageView = UIImageView()
        if let icon = type.icon {
            iconImageView.image = icon
            iconImageView.tintColor = type.textColor
            iconImageView.contentMode = .scaleAspectFit
        } else if type.isLoading {
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.color = type.textColor
            activityIndicator.startAnimating()
            iconImageView.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor)
            ])
        }
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = type.textColor
        titleLabel.font = FontManager.shared.fontApp(family: .cairo, style: .bold, size: .size_16)
        titleLabel.numberOfLines = 1
        
        // Message
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = type.textColor.withAlphaComponent(0.9)
        messageLabel.font = FontManager.shared.fontApp(family: .cairo, style: .regular, size: .size_14)
        messageLabel.numberOfLines = 2
        messageLabel.isHidden = message.isEmpty
        
        // Stack views
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        textStackView.alignment = .leading
        
        let mainStackView = UIStackView(arrangedSubviews: [iconImageView, textStackView])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 12
        mainStackView.alignment = .center
        
        containerView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: DefaultSettings.messageHeight)
        ])
        
        // Tap gesture للإخفاء عند الضغط
        if configuration.isInteractive {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(messageTapped))
            containerView.addGestureRecognizer(tapGesture)
        }
        
        return containerView
    }
    
    /// إنشاء واجهة الحوار
    /// - Parameters:
    ///   - title: عنوان الحوار
    ///   - message: نص الحوار
    ///   - primaryButtonTitle: نص الزر الأساسي
    ///   - secondaryButtonTitle: نص الزر الثانوي
    ///   - primaryAction: إجراء الزر الأساسي
    ///   - secondaryAction: إجراء الزر الثانوي
    /// - Returns: واجهة الحوار
    func createDialogView(
        title: String,
        message: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String?,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)?
    ) -> UIView {
        
        let containerView = UIView()
        containerView.backgroundColor = AppColors.secondBackground.color
        containerView.layer.cornerRadius = DefaultSettings.cornerRadius
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        containerView.layer.shadowRadius = 16
        containerView.layer.shadowOpacity = 0.4
        
        // Icon
        let iconImageView = UIImageView(image: UIImage(systemName: "info.circle.fill"))
        iconImageView.tintColor = AppColors.primary.color
        iconImageView.contentMode = .scaleAspectFit
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = FontManager.shared.fontApp(family: .cairo, style: .bold, size: .size_18)
        titleLabel.textColor = AppColors.text.color
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        // Message
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = FontManager.shared.fontApp(family: .cairo, style: .medium, size: .size_15)
        messageLabel.textColor = AppColors.text.color
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        // Buttons
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually
        
        // Primary button
        let primaryButton = createDialogButton(title: primaryButtonTitle, isPrimary: true) {
            self.hideCurrentDialog()
            primaryAction()
        }
        buttonStackView.addArrangedSubview(primaryButton)
        
        // Secondary button
        if let secondaryTitle = secondaryButtonTitle {
            let secondaryButton = createDialogButton(title: secondaryTitle, isPrimary: false) {
                self.hideCurrentDialog()
                secondaryAction?()
            }
            buttonStackView.addArrangedSubview(secondaryButton)
        }
        
        // Layout
        [iconImageView, titleLabel, messageLabel, buttonStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: min(UIScreen.main.bounds.width - 40, 320)),
            
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return containerView
    }
    
    /// إنشاء زر للحوار
    /// - Parameters:
    ///   - title: نص الزر
    ///   - isPrimary: هل هو الزر الأساسي
    ///   - action: إجراء الزر
    /// - Returns: الزر
    func createDialogButton(title: String, isPrimary: Bool, action: @escaping () -> Void) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = FontManager.shared.fontApp(family: .cairo, style: .semiBold, size: .size_16)
        button.layer.cornerRadius = 8
        
        if isPrimary {
            button.backgroundColor = AppColors.primary.color
            button.setTitleColor(AppColors.buttonText.color, for: .normal)
        } else {
            button.backgroundColor = AppColors.boarderColor.color
            button.setTitleColor(AppColors.text.color, for: .normal)
        }
        
        if #available(iOS 14.0, *) {
            button.addAction(UIAction { _ in
                if let hapticManager = HapticManager.shared as? HapticManager {
                    hapticManager.lightImpact()
                }
                action()
            }, for: .touchUpInside)
        } else {
            // Fallback للإصدارات الأقدم
            button.addTarget(self, action: #selector(handleButtonAction(_:)), for: .touchUpInside)
            button.tag = isPrimary ? 1 : 0
        }
        
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }
    
    /// معالج إجراء الزر للإصدارات الأقدم
    @objc private func handleButtonAction(_ sender: UIButton) {
        if let hapticManager = HapticManager.shared as? HapticManager {
            hapticManager.lightImpact()
        }
        // يجب تطبيق الإجراء المناسب حسب الزر
    }
}
