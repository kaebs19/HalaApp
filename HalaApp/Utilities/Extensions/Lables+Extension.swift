//
//  Lables+Extension.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 06/06/2025.
//

import UIKit

extension UILabel {
    
    /// إعداد Label مخصص
    func setupCustomLable(text: String,
                          textColor: AppColors,
                          ofSize: Sizes,
                          font: Fonts,
                          fontStyle: FontStyle = .regular,
                          alignment: Directions = .auto,
                                                    numberOfLines: Int = 0
                         ) {
        
        self.text = text
        self.textColor = textColor.color
        self.font = FontManager.shared.fontApp(family: font, style: fontStyle, size: ofSize)
        self.textAlignment = alignment.textAlignment

        // تحسينات إضافية
        self.numberOfLines =                           numberOfLines
        self.allowsDefaultTighteningForTruncation = true
        self.adjustsFontForContentSizeCategory = true
    }
    
    /// إعداد زر دائري
    func makeCircular () {
        
        DispatchQueue.main.async {
            self.layer.cornerRadius = min(self.frame.width, self.frame.height) / 2
            self.clipsToBounds = true
        }
    }
}
