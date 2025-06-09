//
//  String+Extension.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import Foundation

extension String: Localizable {
    
    /// تحديث النص في اللغة
    var lolocalized: String {
        return NSLocalizedString(self, comment: "")
    }
}
