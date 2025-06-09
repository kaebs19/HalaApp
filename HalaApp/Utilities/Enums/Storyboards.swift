//
//  Storyboards.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit


enum Storyboards: String {
    
    case Onboarding = "Onboarding"
    case Main = "Main"
    case Auth = "Auth"
 
    /// الحصول على UIStoryboard
    var storyboard: UIStoryboard {
        UIStoryboard(name: self.rawValue, bundle: .main)
    }
    
    /// إنشاء ViewController من الـ Storyboard
    func instantiateViewController(withIdentifier identifier: Identifiers) -> UIViewController? {
        return storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
    }

    
}
