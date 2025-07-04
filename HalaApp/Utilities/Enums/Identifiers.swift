//
//  Identifiers.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import Foundation

enum Identifiers: String {
    
    case Onboarding = "OnboardingVC"
    case Login = "LoginVC"
    case SignUp = "SignUpVC"
    case ForgotPassword = "ForgotPasswordVC"
   // case Main = "MainTabBars"
    
    case Settings = "SettingsVC"
    case Profile = "ProfileVC"
    case Home = "HomeVC"
    case Messages = "MessagesVC"
    case Notifications = "NotificationVC"
    case Acounts = "AccountVC"
    
    var identifierName: String {
        return self.rawValue
    }
}
