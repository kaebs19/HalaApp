//
//  Placeholder.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 12/06/2025.
//

import UIKit

enum Placeholders: String {
    
    case empty = ""
    case email = "EmailTFPlaceholder"
    case password = "PasswordTFPlaceholder"
    case confirmPassword = "ConfirmPasswordTFPlaceholder"
    case name = "NameTFPlaceholder"
    case username = "UsernameTFPlaceholder"
    case dateOfBirth = "DateOfBirthTFPlaceholder"

    var PlaceholderText: String {
        return self.rawValue.localized
    }
}

