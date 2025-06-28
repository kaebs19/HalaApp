//
//  NavigationConfig.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 20/06/2025.
//

import UIKit

// MARK: - Navigation Configuration
struct NavigationConfig {
    var title: String?
    var isLargeTitleEnabled: Bool = false
    var leftButton: NavigationButton?
    var rightButton: NavigationButton?
    var leftButtons: [NavigationButton]?
    var rightButtons: [NavigationButton]?
    var backgroundColor: AppColors = .background
    var titleColor: AppColors = .text
    var tintColor: AppColors = .text
    var hideNavigationBar: Bool = false
    var isTranslucent: Bool = true
    
    static let `default` = NavigationConfig()
}

// MARK: - Navigation Button Configuration
struct NavigationButton {
    let type: NavigationButtonType
    let action: (() -> Void)?
    let isEnabled: Bool
    let badge: String?
    
    init(type: NavigationButtonType, action: (() -> Void)? = nil, isEnabled: Bool = true, badge: String? = nil) {
        self.type = type
        self.action = action
        self.isEnabled = isEnabled
        self.badge = badge
    }
}
