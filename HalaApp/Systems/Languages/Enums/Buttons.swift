//
//  Buttons.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import Foundation

enum Buttons: String   {
    
    case test = "testButton"
    case skip = "skipButton"
    case login = "loginButton"
    case signup = "registerButton"
    case forgotPassword = "forgotPasswordButton"
    case terms = "TermsButton"
    case conditions = "ConditionsButton"
    case send = "sendButton"
    case done = "doneButton"
    case cancel = "cancelButton"
    case Continuation = "continuationButton"
    

    var titleButton: String {
        return self.rawValue.localized
    }
}
