//
//  Images.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 15/06/2025.
//

import Foundation
import UIKit

enum AppImage: String {
    
    case apple = "apple"
    case back = "back"
    case logo = "logo"
    case close = "close"
    case menu = "menu"
    case forward = "forward"
    case google = "google"
    case mark = "mark"
    case morefill = "more-fill"
    case notification = "notification"
    case search = "search"
    case notificationIcon = "notificationIcon"
    case refresh = "refresh"
    case rememberMe = "RememberMe"
    case save = "save"
    case share = "share"
    case version = "version"
    case logout = "logout"
    
    // TabBars
        case homeSelected = "home_Select"
       case homeUnselected = "home_UnSelect"
       case messageSelected = "message_Select"
       case messageUnselected = "message_UnSelect"
       case notificationSelected = "notifications_Select"
       case notificationUnselected = "notifications_UnSelect"
       case accountSelected = "account_Select"
       case accountUnselected = "account_UnSelect"

    
    
    var imageName: String {
        return self.rawValue
    }
}
