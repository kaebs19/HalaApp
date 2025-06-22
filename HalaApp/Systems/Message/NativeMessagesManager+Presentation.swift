//
//  NativeMessagesManager+Presentation.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

// MARK: - Presentation Methods (طرق العرض والتقديم)
extension NativeMessagesManager {
    
    /// عرض الرسالة على الشاشة
    /// - Parameters:
    ///   - messageView: واجهة الرسالة
    ///   - configuration: إعدادات العرض
    func presentMessage(_ messageView: UIView, configuration: MessageConfiguration) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        currentMessageView = messageView
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        if configuration.dimBackground {
            createOverlayWindow()
        }
        
        window.addSubview(messageView)
        
        let initialTransform: CGAffineTransform
        let finalConstraints: [NSLayoutConstraint]
        
        switch configuration.position {
        case .top:
            initialTransform = CGAffineTransform(translationX: 0, y: -200)
            finalConstraints = [
                messageView.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: DefaultSettings.verticalMargin),
                messageView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: DefaultSettings.horizontalMargin),
                messageView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -DefaultSettings.horizontalMargin)
            ]
            
        case .bottom:
            initialTransform = CGAffineTransform(translationX: 0, y: 200)
            finalConstraints = [
                messageView.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -DefaultSettings.verticalMargin),
                messageView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: DefaultSettings.horizontalMargin),
                messageView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -DefaultSettings.horizontalMargin)
            ]
            
        case .center:
            initialTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            finalConstraints = [
                messageView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                messageView.centerYAnchor.constraint(equalTo: window.centerYAnchor),
                messageView.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: DefaultSettings.horizontalMargin),
                messageView.trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor, constant: -DefaultSettings.horizontalMargin)
            ]
        }
        
        messageView.transform = initialTransform
        messageView.alpha = 0
        
        NSLayoutConstraint.activate(finalConstraints)
        window.layoutIfNeeded()
        
        UIView.animate(withDuration: DefaultSettings.animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            messageView.transform = .identity
            messageView.alpha = 1
        }
    }
    
    /// عرض الحوار على الشاشة
    /// - Parameter dialogView: واجهة الحوار
    func presentDialog(_ dialogView: UIView) {
        createOverlayWindow()
        
        guard let overlayWindow = overlayWindow else { return }
        
        currentDialogView = dialogView
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        
        overlayWindow.addSubview(dialogView)
        
        NSLayoutConstraint.activate([
            dialogView.centerXAnchor.constraint(equalTo: overlayWindow.centerXAnchor),
            dialogView.centerYAnchor.constraint(equalTo: overlayWindow.centerYAnchor)
        ])
        
        dialogView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        dialogView.alpha = 0
        
        UIView.animate(withDuration: DefaultSettings.animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            dialogView.transform = .identity
            dialogView.alpha = 1
        }
    }
    
    /// إنشاء نافذة التعتيم للخلفية
    func createOverlayWindow() {
        guard overlayWindow == nil else { return }
        
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                overlayWindow = UIWindow(windowScene: windowScene)
            }
        } else {
            overlayWindow = UIWindow(frame: UIScreen.main.bounds)
        }
        
        overlayWindow?.windowLevel = UIWindow.Level.alert
        overlayWindow?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayWindow?.isHidden = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        overlayWindow?.addGestureRecognizer(tapGesture)
    }
}
