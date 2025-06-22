//
//  Images.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 15/06/2025.
//

import Foundation
import UIKit

enum Images: String {
    
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
    
    
    var imageName: String {
        return self.rawValue
    }
}
