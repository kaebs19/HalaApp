//
//  BodyMessage.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 10/06/2025.
//

import Foundation

enum BodyMessage: String {
    case empty = ""
    case success = "SuccessBody"
    case failure = "FailureBody"
    case unknown = "UnknownBody"
    case networkError = "NetworkErrorBody"
    case internetConnection = "InternetConnectionBody"
    case fillAllFields = "FillAllFieldsBody"
    case dataValidation = "DataValidationBody"
    case updateDescription = "UpdateDescriptionBody"
    case deleteConfirmation = "DeleteConfirmationBody"
    case pleaseWait = "PleaseWaitBody"
    
    var textMessage: String {
        return self.rawValue.localized
    }
}
