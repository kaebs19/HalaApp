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
                          font: Fonts = .cairo,
                          fontStyle: FontStyle = .regular,
                          alignment: Directions = .auto,
                          numberOfLines: Int = 0,
                          responsive: Bool = true
                         ) {
        
        self.text = text
        self.textColor = textColor.color
        self.font = FontManager.shared.fontApp(family: font, style: fontStyle, size: ofSize)
        self.textAlignment = alignment.textAlignment

        // تحسينات إضافية
        self.numberOfLines =                           numberOfLines
        self.allowsDefaultTighteningForTruncation = true
        self.adjustsFontForContentSizeCategory = true
        
        // اختيار الخط حسب التجاوب
        if responsive {
            self.font = FontManager.shared.responsiveFont(family: font, style: fontStyle, size: ofSize)
        } else {
            self.font = FontManager.shared.fontApp(family: font, style: fontStyle, size: ofSize)
        }

    }
    

}
