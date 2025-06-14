//
//  TitleMessage.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 10/06/2025.
//

import Foundation


// MARK: - Message Text Enums
enum TitleMessage: String {
    case empty = ""
    case loading = "LoadingTitle"
    case success = "SuccessTitle"
    case error = "ErrorTitle"
    case warning = "WarningTitle"
    case info = "InfoTitle"
    case networkError = "NetworkErrorTitle"
    case validation = "ValidationTitle"
    case required = "RequiredTitle"
    case saving = "SavingTitle"
    case uploading = "UploadingTitle"
    case connecting = "ConnectingTitle"
    case updateAvailable = "UpdateAvailableTitle"
    case confirmDelete = "ConfirmDeleteTitle"
    
  
    
    var title: String {
        return self.rawValue.localized
    }
}
