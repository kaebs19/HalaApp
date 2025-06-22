//
//  SignUpVC.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 20/06/2025.
//

import UIKit

class SignUpVC: UIViewController {

    // MARK: - Outlets

    
    // MARK: - Properties

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeThemeObserver()
        
        // تنظيف الرسائل المعلقة - مهم جداً!
        NativeMessagesManager.shared.hide()
        
        
    }
    

}


extension SignUpVC {
    
    private func setupUI() {
        // تطبيق السمات
        ThemeManager.shared.applyStoredTheme()
        
        setNavigationTitle(.signup , isLarge: true)
        setNavigationCloseButton()
    }
}
