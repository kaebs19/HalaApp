//
//  Title.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 20/06/2025.
//

import Foundation

enum Title: String {
    
    case login = "LoginTitle"
    case signup = "SignupTitle"
    case forgotPassword = "ForgotPasswordTitle"
    case home = "HomeTitle"
    case profile = "ProfileTitle"
    case settings = "SettingsTitle"
    case notifications = "NotificationsTitle"
    case messages = "MessagesTitle"
    
    var TextTitle: String {
        return self.rawValue.localized
    }
}
