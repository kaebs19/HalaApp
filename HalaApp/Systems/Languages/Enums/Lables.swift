//
//  Lables.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import Foundation

enum Lables: String {
    
    case loading = "Loading..."
    
    var textName: String {
        return self.rawValue.lolocalized
    }
}
