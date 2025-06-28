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
    
    case dateOfBirth = "DateOfBirthBody"
    case minimumAge = "MinimumAgeBody"
    case maximumAge = "MaximumAgeBody"
    case age = "AgeBody"
    case year = "YearBody"
    case month = "MonthBody"
    case day = "DayBody"
    case ageHasBeenSet = "AgeHasBeenSetBody"
    case ageIsInvalid = "AgeIsInvalidBody"
    
    var textMessage: String {
        return self.rawValue.localized
    }
}
