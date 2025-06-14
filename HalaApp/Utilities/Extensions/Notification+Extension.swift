//
//  Notification+Extension.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import Foundation


extension Notification.Name {
    static let themeDidChange = Notification.Name("themeDidChange")
    static let themeWillChange = Notification.Name("themeWillChange")
    
    //
    static let appDidBecomeActive = Notification.Name("appDidBecomeActive")
    static let appWillResignActive = Notification.Name("appWillResignActive")
    static let appWillEnterForeground = Notification.Name("appWillEnterForeground")
    static let appDidEnterBackground = Notification.Name("appDidEnterBackground")


    static let hapticSettingsChanged = Notification.Name("hapticSettingsChanged")
    static let themeSettingsChanged = Notification.Name("themeSettingsChanged")
    static let languageSettingsChanged = Notification.Name("languageSettingsChanged")

}
