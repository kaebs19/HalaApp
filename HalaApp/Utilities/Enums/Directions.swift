//
//  Directions.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

    import UIKit
    import MOLH


    /// اتجاهات النص
    enum Directions: String, CaseIterable {
        
        case right
        case left
        case center
        case auto
        
        var textAlignment: NSTextAlignment {
            
            switch self {
                    
                case .right:
                    return .right
                case .left:
                    return .left
                case .center:
                    return .center
                case .auto:
                    return MOLHLanguage.isRTLLanguage() ? .right : .left
            }
        }
    }
