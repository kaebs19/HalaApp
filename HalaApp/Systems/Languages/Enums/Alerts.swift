//
//  Alerts.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 13/06/2025.
//

import Foundation

enum Alerts: String  {
    case email = "EmailAlert"
    case password = "PasswordAlert"
    case RequiredPassword = "RequiredPasswordAlert"
    case RequiredEmail = "RequiredEmailAlert"
    case invalidMail = "InvalidEmailAlert"
    case invalidPassword = "InvalidPasswordAlert"
    case Error = "ErrorAlert"
    case PleaseFillAllFields = "PleaseFillAllFieldsAlert"
    case PasswordDoesNotMatch = "PasswordDoesNotMatchAlert"
    case YouMastAgreeToTermsAndConditions = "YouMastAgreeToTermsAndConditionsAlert"
    case EmailOrPasswordIsEmptyAlert = "EmailOrPasswordIsEmptyAlert"
    case Success = "SuccessAlert"
    case Successfully = "SuccessfullyLoggedInAlert"
    case PasswordIsShort = "PasswordIsShortAlert"
    case EmailFormatIsIncorrect = "EmailFormatIsIncorrectAlert"
    case PasswordIsEmpty = "PasswordIsEmptyAlert"
    case EmailIsEmpty = "EmailIsEmptyAlert"
    case warning = "WarningAlert"
    case warningMessage = "WarningMessageAlert"
    case yes = "YesAlert"
    case no = "NoAlert"
    case cancel = "CancelAlert"
    case AddedFavoritesList = "AddedToYourFavoritesListAlert"
    case RemovedFavoritesList = "RemovedFromYourFavoritesListAlert"
    case FavoritesUpdateTitle = "FavoritesUpdateTitleAlert"
    case ChooseImage = "ChooseImageAlert"
    case DetailsChooseImage = "DetailsChooseImageAlert"
    case Camera      = "CameraAlert"
    case PhotoLabary    = "PhotoLabaryAlert"

    case Delete = "DeleteAlert"
    case Refresh = "RefreshAlert"
    case Skip = "SkipAlert"
    
    
    var texts: String {
        return self.rawValue.localized
    }
}
