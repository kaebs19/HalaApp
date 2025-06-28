//
//  Lables.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import Foundation

enum Lables: String {
    
    case loading = "Loading..."
    case findNew = "FindNewLab"
    case findNewSubtitle = "FindNewSubtitleLab"
    case login = "loginLabel"
    case signup = "registerLabel"
    case welcome = "welcomeLabel"
    case welcomeSubtitle = "welcomeSubtitleLabel"
    case createAccount = "createAccountLabel"
    case argeement = "argeementLabel"
    case iAgree = "iAgreeLabel"
    case forgotPasswordSubtitle = "forgotPasswordSubtitleLabel"
    case Logout = "LogoutLable"
    case qrCodeSubtitle = "qrCodeSubtitleLabel"
    case lightMode = "lightModeLabel"
    case darkMode = "darkModeLabel"
    case selectLanguage = "selectLanguageLabel"
    case rememberMe = "rememberMeLabel"
    case iHaveReadAndAgree = "iHaveReadAndAgreeLabel"
    case dontHaveAccount = "dontHaveAccountLabel"
    case orContinueWith = "orContinueWithLabel"
    case selectDate = "selectDateLabel"
    
    var textName: String {
          return self.rawValue.localized
    }
}
