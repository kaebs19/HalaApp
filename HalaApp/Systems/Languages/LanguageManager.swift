//
//  LanguageManager.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit
import MOLH

class LanguageManager: NSObject , MOLHResetable {
 
    
    
    /// الحصول على برجية اللغة
    static let shared = LanguageManager()
    private override init(){}
    
    // MARK: - Properties
    
    
    // MARK: - Properties

    /// اعادة تعين اللغة
    func reset() {
        print("اعادة تعين اللغة")
    }
    
    public func isEnglish() -> Bool {
        
        if MOLHLanguage.isArabic() {
            return false
        } else {
            return true
        }
    }
}
