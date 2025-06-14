//
//  MessagesManager.swift
//  HalaApp
//
//  نظام إدارة الرسائل المُحسَّن والمُصحح
//

import SwiftMessages
import UIKit


// MARK: - MessagesManager Class
class MessagesManager {
    
    // MARK: - Singleton
    static let shared = MessagesManager()
    private init() {}
    
    // MARK: - Properties
    private let actionHandler = ButtonActionHandler()
    
    // MARK: - Configuration
    
    /// إعدادات افتراضية للرسائل
    private struct DefaultSettings {
        static let duration: TimeInterval = 3.0
        static let cornerRadius: CGFloat = 12
        static let shadowOpacity: Float = 0.3
        static let hapticEnabled: Bool = true
        static let interactiveHide: Bool = true
    }
    
    /// أنواع الرسائل المدعومة
    enum MessageType: Equatable {
        case success
        case error
        case warning
        case info
        case loading
        case custom(backgroundColor: AppColors, textColor: AppColors, icon: UIImage?)
        
        // تنفيذ Equatable
        static func == (lhs: MessageType, rhs: MessageType) -> Bool {
            switch (lhs, rhs) {
            case (.success, .success), (.error, .error), (.warning, .warning), (.info, .info), (.loading, .loading):
                return true
            case (.custom(let lhsBg, let lhsText, _), .custom(let rhsBg, let rhsText, _)):
                return lhsBg == rhsBg && lhsText == rhsText
            default:
                return false
            }
        }
        
        var theme: Theme {
            switch self {
            case .success: return .success
            case .error: return .error
            case .warning: return .warning
            case .info, .loading: return .info
            case .custom: return .info
            }
        }
        
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
                return nil // سيتم إضافة مؤشر تحميل
            case .custom(_, _, let icon):
                return icon
            }
        }
        
        var hapticType: UINotificationFeedbackGenerator.FeedbackType? {
            switch self {
            case .success: return .success
            case .error: return .error
            case .warning: return .warning
            case .info, .loading, .custom: return nil
            }
        }
    }
    
    /// مواضع عرض الرسائل
    enum Position {
        case top
        case bottom
        case center
        
        var presentationStyle: SwiftMessages.PresentationStyle {
            switch self {
            case .top: return .top
            case .bottom: return .bottom
            case .center: return .center
            }
        }
    }
    
    /// إعدادات الرسالة
    struct MessageConfiguration {
        var duration: TimeInterval = DefaultSettings.duration
        var position: Position = .top
        var interactive: Bool = DefaultSettings.interactiveHide
        var haptic: Bool = DefaultSettings.hapticEnabled
        var dimBackground: Bool = false
        var cornerRadius: CGFloat = DefaultSettings.cornerRadius
        var showButton: Bool = false // إضافة خيار إظهار/إخفاء الزر
        
        static let `default` = MessageConfiguration()
    }
}

// MARK: - Button Actions Handler
/// معالج إجراءات الأزرار لحل مشكلة stored properties في extension
private class ButtonActionHandler {
    var primaryAction: (() -> Void)?
    var secondaryAction: (() -> Void)?
    
    @MainActor @objc func primaryButtonTapped() {
        SwiftMessages.hide()
        primaryAction?()
        cleanup()
    }
    
    @MainActor @objc func secondaryButtonTapped() {
        SwiftMessages.hide()
        secondaryAction?()
        cleanup()
    }
    
    private func cleanup() {
        primaryAction = nil
        secondaryAction = nil
    }
}

// MARK: - Main Functions
extension MessagesManager {
    
    /// 🎯 عرض رسالة احترافية
    func show(
        title: String,
        message: String = "",
        type: MessageType,
        configuration: MessageConfiguration = .default
    ) {
        DispatchQueue.main.async {
            // إنشاء المظهر
            let view = self.createMessageView(
                title: title,
                message: message,
                type: type,
                configuration: configuration
            )
            
            // تطبيق الإعدادات
            let config = self.createConfiguration(from: configuration)
            
            // تأثير الاهتزاز
            if configuration.haptic {
                self.generateHaptic(for: type)
            }
            
            // عرض الرسالة
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    /// 🎯 عرض رسالة مع enum للنصوص
    func show(
        titleType: TitleMessage,
        messageType: BodyMessage = .empty,
        type: MessageType,
        configuration: MessageConfiguration = .default
    ) {
        show(
            title: titleType.title,
            message: messageType.textMessage,
            type: type,
            configuration: configuration
        )
    }
    
    /// ✅ رسالة نجاح
    func showSuccess(
        title: String,
        message: String = "",
        configuration: MessageConfiguration = .default
    ) {
        show(title: title, message: message, type: .success, configuration: configuration)
    }
    
    /// ✅ رسالة نجاح مع enum
    func showSuccess(
        titleType: TitleMessage = .success,
        messageType: BodyMessage = .success,
        configuration: MessageConfiguration = .default
    ) {
        show(titleType: titleType, messageType: messageType, type: .success, configuration: configuration)
    }
    
    /// ❌ رسالة خطأ
    func showError(
        title: String,
        message: String = "",
        configuration: MessageConfiguration = .default
    ) {
        show(title: title, message: message, type: .error, configuration: configuration)
    }
    
    /// ❌ رسالة خطأ مع enum
    func showError(
        titleType: TitleMessage = .error,
        messageType: BodyMessage = .failure,
        configuration: MessageConfiguration = .default
    ) {
        show(titleType: titleType, messageType: messageType, type: .error, configuration: configuration)
    }
    
    /// ⚠️ رسالة تحذير
    func showWarning(
        title: String,
        message: String = "",
        configuration: MessageConfiguration = .default
    ) {
        show(title: title, message: message, type: .warning, configuration: configuration)
    }
    
    /// ⚠️ رسالة تحذير مع enum
    func showWarning(
        titleType: TitleMessage = .warning,
        messageType: BodyMessage = .fillAllFields,
        configuration: MessageConfiguration = .default
    ) {
        show(titleType: titleType, messageType: messageType, type: .warning, configuration: configuration)
    }
    
    /// ℹ️ رسالة معلومات
    func showInfo(
        title: String,
        message: String = "",
        configuration: MessageConfiguration = .default
    ) {
        show(title: title, message: message, type: .info, configuration: configuration)
    }
    
    /// ℹ️ رسالة معلومات مع enum
    func showInfo(
        titleType: TitleMessage = .info,
        messageType: BodyMessage = .empty,
        configuration: MessageConfiguration = .default
    ) {
        show(titleType: titleType, messageType: messageType, type: .info, configuration: configuration)
    }
    
    /// 🔄 رسالة تحميل
    func showLoading(
        title: String = TitleMessage.loading.title,
        message: String = BodyMessage.pleaseWait.textMessage,
        dimBackground: Bool = true
    ) {
        var config = MessageConfiguration.default
        config.duration = -1 // إلى الأبد
        config.interactive = false
        config.dimBackground = dimBackground
        config.haptic = false
        
        show(title: title, message: message, type: .loading, configuration: config)
    }
    
    /// 🔄 رسالة تحميل مع enum
    func showLoading(
        titleType: TitleMessage = .loading,
        messageType: BodyMessage = .pleaseWait,
        dimBackground: Bool = true
    ) {
        showLoading(title: titleType.title, message: messageType.textMessage, dimBackground: dimBackground)
    }
    
    /// 🎨 رسالة مخصصة
    func showCustom(
        title: String,
        message: String = "",
        backgroundColor: AppColors,
        textColor: AppColors = .buttonText,
        icon: UIImage? = nil,
        configuration: MessageConfiguration = .default
    ) {
        let customType = MessageType.custom(
            backgroundColor: backgroundColor,
            textColor: textColor,
            icon: icon
        )
        show(title: title, message: message, type: customType, configuration: configuration)
    }
}

// MARK: - Interactive Messages
extension MessagesManager {
    
    /// 📋 رسالة تفاعلية مع زر
    func showInteractive(
        title: String,
        message: String,
        buttonTitle: String,
        type: MessageType = .info,
        action: @escaping () -> Void
    ) {
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .cardView)
            
            // تطبيق الثيم
            if case .custom(let bgColor, let textColor, _) = type {
                view.configureTheme(backgroundColor: bgColor.color, foregroundColor: textColor.color)
            } else {
                view.configureTheme(type.theme)
            }
            
            // المحتوى مع الزر
            view.configureContent(
                title: title,
                body: message,
                iconImage: type.icon,
                iconText: nil,
                buttonImage: nil,
                buttonTitle: buttonTitle
            ) { _ in
                SwiftMessages.hide()
                action()
            }
            
            // تخصيص المظهر
            self.styleMessageView(view, cornerRadius: DefaultSettings.cornerRadius)
            
            // الإعدادات
            var config = SwiftMessages.defaultConfig
            config.duration = .forever
            config.presentationStyle = .top
            config.interactiveHide = false
            
            // تأثير الاهتزاز
            self.generateHaptic(for: type)
            
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    /// 💬 رسالة حوار مع خيارات
    func showDialog(
        title: String,
        message: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.info)
            
            // إعداد الإجراءات
            self.actionHandler.primaryAction = primaryAction
            self.actionHandler.secondaryAction = secondaryAction
            
            // إنشاء الأزرار المخصصة
            let buttonStackView = UIStackView()
            buttonStackView.axis = .horizontal
            buttonStackView.spacing = 12
            buttonStackView.distribution = .fillEqually
            
            // الزر الأساسي
            let primaryButton = UIButton(type: .system)
            primaryButton.setTitle(primaryButtonTitle, for: .normal)
            primaryButton.backgroundColor = AppColors.primary.color
            primaryButton.setTitleColor(AppColors.buttonText.color, for: .normal)
            primaryButton.layer.cornerRadius = 8
            primaryButton.addTarget(self.actionHandler, action: #selector(self.actionHandler.primaryButtonTapped), for: .touchUpInside)
            
            buttonStackView.addArrangedSubview(primaryButton)
            
            // الزر الثانوي (اختياري)
            if let secondaryTitle = secondaryButtonTitle {
                let secondaryButton = UIButton(type: .system)
                secondaryButton.setTitle(secondaryTitle, for: .normal)
                secondaryButton.backgroundColor = AppColors.textSecondary.color
                secondaryButton.setTitleColor(AppColors.buttonText.color, for: .normal)
                secondaryButton.layer.cornerRadius = 8
                secondaryButton.addTarget(self.actionHandler, action: #selector(self.actionHandler.secondaryButtonTapped), for: .touchUpInside)
                
                buttonStackView.addArrangedSubview(secondaryButton)
            }
            
            // المحتوى الأساسي
            view.configureContent(title: title, body: message)
            
            // إضافة الأزرار
            view.addSubview(buttonStackView)
            buttonStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
                buttonStackView.heightAnchor.constraint(equalToConstant: 44)
            ])
            
            self.styleMessageView(view, cornerRadius: DefaultSettings.cornerRadius)
            
            var config = SwiftMessages.defaultConfig
            config.duration = .forever
            config.presentationStyle = .center
            config.dimMode = .gray(interactive: false)
            
            SwiftMessages.show(config: config, view: view)
        }
    }
}

// MARK: - Control Functions
extension MessagesManager {
    
    /// 🔕 إخفاء الرسالة الحالية
    func hide() {
        DispatchQueue.main.async {
            SwiftMessages.hide()
        }
    }
    
    /// 🔕 إخفاء جميع الرسائل
    func hideAll() {
        DispatchQueue.main.async {
            SwiftMessages.hideAll()
        }
    }
    
    /// 📊 التحقق من وجود رسائل معروضة
//    var hasActiveMessages: Bool {
//        return SwiftMessages.current() != nil
//    }
    
    /// 🧹 مسح قائمة انتظار الرسائل
    func clearQueue() {
        DispatchQueue.main.async {
            SwiftMessages.hideAll()
        }
    }
}

// MARK: - Helper Functions
private extension MessagesManager {
    
    /// إنشاء عرض الرسالة
    func createMessageView(
        title: String,
        message: String,
        type: MessageType,
        configuration: MessageConfiguration
    ) -> MessageView {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        
        // تطبيق الثيم
        if case .custom(let bgColor, let textColor, _) = type {
            view.configureTheme(backgroundColor: bgColor.color, foregroundColor: textColor.color)
        } else {
            view.configureTheme(type.theme)
        }
        
        // المحتوى
        if type == .loading {
            // رسالة تحميل خاصة
            configureLoadingMessage(view, title: title, message: message)
        } else {
            // التحقق من وجود أيقونة قبل استخدامها
            let iconImage = type.icon!
            view.configureContent(
                title: title,
                body: message.isEmpty ? "" : message,
                iconImage: iconImage
            )
        }
        
        // إخفاء الزر في الرسائل العادية (غير التفاعلية)
        view.button?.isHidden = !configuration.showButton
        
        // تخصيص المظهر
        styleMessageView(view, cornerRadius: configuration.cornerRadius)
        
        return view
    }
    
    /// تخصيص مظهر الرسالة
    func styleMessageView(_ view: MessageView, cornerRadius: CGFloat) {
        // الهوامش
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // الزوايا المنحنية
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = cornerRadius
        
        // الظل
        view.backgroundView.layer.shadowColor = UIColor.black.cgColor
        view.backgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.backgroundView.layer.shadowRadius = 4
        view.backgroundView.layer.shadowOpacity = DefaultSettings.shadowOpacity
        
        // الخطوط
        if let titleLabel = view.titleLabel {
            titleLabel.font = FontManager.shared.fontApp(family: .cairo, style: .bold, size: .size_16)
        }
        
        if let bodyLabel = view.bodyLabel {
            bodyLabel.font = FontManager.shared.fontApp(family: .cairo, style: .medium, size: .size_14)
        }
        
        // إخفاء الزر افتراضياً إذا لم يكن له وظيفة
        if let button = view.button {
            button.titleLabel?.font = FontManager.shared.fontApp(family: .cairo, style: .semiBold, size: .size_14)
            // إخفاء الزر إذا لم يكن له عنوان أو وظيفة
            if button.title(for: .normal)?.isEmpty == true || button.title(for: .normal) == nil {
                button.isHidden = true
            }
        }
    }
    
    /// إعداد رسالة التحميل
    func configureLoadingMessage(_ view: MessageView, title: String, message: String) {
        view.configureContent(
            title: title,
            body: message.isEmpty ? "" : message
        )
        
        // إضافة مؤشر التحميل
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        
        // إخفاء الأيقونة الافتراضية
        view.iconImageView?.isHidden = true
        
        // إضافة المؤشر
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    /// إنشاء إعدادات SwiftMessages
    @MainActor func createConfiguration(from config: MessageConfiguration) -> SwiftMessages.Config {
        var swiftConfig = SwiftMessages.defaultConfig
        
        // المدة
        if config.duration > 0 {
            swiftConfig.duration = .seconds(seconds: config.duration)
        } else {
            swiftConfig.duration = .forever
        }
        
        // الموضع
        swiftConfig.presentationStyle = config.position.presentationStyle
        
        // التفاعل
        swiftConfig.interactiveHide = config.interactive
        
        // الخلفية المعتمة
        if config.dimBackground {
            swiftConfig.dimMode = .gray(interactive: config.interactive)
        } else {
            swiftConfig.dimMode = .none
        }
        
        // إعدادات إضافية
        swiftConfig.presentationContext = .window(windowLevel: .statusBar)
        swiftConfig.shouldAutorotate = true
        
        return swiftConfig
    }
    
    /// تأثير الاهتزاز
    func generateHaptic(for type: MessageType) {
        if let hapticType = type.hapticType {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(hapticType)
        } else {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
}

// MARK: - Convenience Extensions (مع دعم النصوص المترجمة)
extension MessagesManager {
    
    /// 🚀 رسائل سريعة للشبكة
    func showNetworkError() {
        showError(
            titleType: .networkError,
            messageType: .internetConnection
        )
    }
    
    func showNetworkSuccess() {
        showSuccess(titleType: .success, messageType: .success)
    }
    
    /// 🔄 رسائل التحميل المخصصة
    func showSaving() {
        showLoading(titleType: .saving, messageType: .pleaseWait, dimBackground: true)
    }
    
    func showUploading() {
        showLoading(titleType: .uploading, messageType: .pleaseWait, dimBackground: true)
    }
    
    func showConnecting() {
        showLoading(titleType: .connecting, messageType: .pleaseWait, dimBackground: false)
    }
    
    /// 📝 رسائل التحقق من صحة البيانات
    func showValidationError(_ message: String = "") {
        let bodyMessage = message.isEmpty ? BodyMessage.dataValidation.textMessage : message
        showWarning(title: TitleMessage.validation.title, message: bodyMessage)
    }
    
    func showFieldRequired(_ fieldName: String) {
        showWarning(
            title: TitleMessage.required.title,
            message: "\(fieldName) مطلوب"
        )
    }
    
    /// 💬 حوار تأكيد الحذف
    func showDeleteConfirmation(
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        showDialog(
            title: TitleMessage.confirmDelete.title,
            message: BodyMessage.deleteConfirmation.textMessage,
            primaryButtonTitle: "حذف",
            secondaryButtonTitle: "إلغاء",
            primaryAction: onConfirm,
            secondaryAction: onCancel
        )
    }
    
    /// 🔄 حوار التحديث
    func showUpdateDialog(
        onUpdate: @escaping () -> Void,
        onSkip: (() -> Void)? = nil
    ) {
        showDialog(
            title: TitleMessage.updateAvailable.title,
            message: BodyMessage.updateDescription.textMessage,
            primaryButtonTitle: "تحديث",
            secondaryButtonTitle: "تخطي",
            primaryAction: onUpdate,
            secondaryAction: onSkip
        )
    }
}

/*
 📚 أمثلة محسنة على الاستخدام:
 
 // 1️⃣ الرسائل الأساسية (بالنصوص المترجمة)
 MessagesManager.shared.showSuccess()                    // عنوان ونص افتراضي
 MessagesManager.shared.showError()                      // عنوان ونص افتراضي
 MessagesManager.shared.showWarning()                    // عنوان ونص افتراضي
 
 // 2️⃣ رسائل مع نصوص مخصصة
 MessagesManager.shared.showSuccess(title: "تم الحفظ!", message: "تفاصيل إضافية")
 
 // 3️⃣ رسائل مع enum للنصوص
 MessagesManager.shared.show(
     titleType: .success,
     messageType: .success,
     type: .success
 )
 
 // 4️⃣ رسائل سريعة جاهزة
 MessagesManager.shared.showNetworkError()
 MessagesManager.shared.showSaving()
 MessagesManager.shared.showValidationError()
 
 // 5️⃣ حوارات جاهزة
 MessagesManager.shared.showDeleteConfirmation {
     print("تم تأكيد الحذف")
 }
 
 MessagesManager.shared.showUpdateDialog {
     print("بدء التحديث")
 } onSkip: {
     print("تم تخطي التحديث")
 }
 
 // 6️⃣ رسائل تحميل
 MessagesManager.shared.showLoading()                    // نص افتراضي
 MessagesManager.shared.showLoading(titleType: .saving)  // نص مخصص
 
 // 7️⃣ التحكم في الرسائل
 MessagesManager.shared.hide()
 MessagesManager.shared.hideAll()
 
 */
