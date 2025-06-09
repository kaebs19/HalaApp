//
//  Languages.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import Foundation

// MARK: - Language Model

public struct Language {
    
    public  let code: String
    public  let name: String
    public  let nativeName: String
    public  let isRTL: Bool
    
    public  static let english = Language(code: "en", name: "English", nativeName: "English", isRTL: false)
    public   static let arabic = Language(code: "ar", name: "Arabic", nativeName: "العربية", isRTL: true)
    public  static let all: [Language] = [english, arabic]
    
    public init(code: String, name: String, nativeName: String, isRTL: Bool) {
        self.code = code
        self.name = name
        self.nativeName = nativeName
        self.isRTL = isRTL
    }
}
