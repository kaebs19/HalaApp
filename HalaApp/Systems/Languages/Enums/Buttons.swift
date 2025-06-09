//
//  Buttons.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import Foundation

enum Buttons: String   {
    
    case skip = "SkipButton"
    case Continuation = "ContinueButton"
    case SignIn = "SignInButton"
    case SignUp = "SignUpButton"
    case SignOut = "SignOutButton"
    
    
    var titleButton: String {
        return self.rawValue.lolocalized
    }
}
