//
//  View+Extension.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 07/06/2025.
//

import UIKit

extension UIView {
    
    /// إعداد خلفية بلون من AppColors
    func setBackgroundColor(_ color: AppColors) {
        self.backgroundColor = color.color
    }
    
    /// إعداد حدود ملونة
    func addBoarder(color: AppColors , width: CGFloat = 1.0) {
        self.layer.borderColor = color.color.cgColor
        self.layer.borderWidth = width
    }
    
    /// إعداد ظل ملون
       func setShadow(color: AppColors, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4, opacity: Float = 0.3) {
           self.layer.shadowColor = color.color.cgColor
           self.layer.shadowOffset = offset
           self.layer.shadowRadius = radius
           self.layer.shadowOpacity = opacity
           self.layer.masksToBounds = false
    }
    
    /// إعداد الزوايا المنحنية
    func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    /// إعداد تدرج لوني للخلفية
    func applyGradientBackground(colors: [Gradients],
                                direction: GradientDirection = .topToBottom) {
          let gradientLayer = CAGradientLayer()
          gradientLayer.colors = colors.map { $0.color.cgColor }
          gradientLayer.frame = bounds
          
          switch direction {
          case .topToBottom:
              gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
              gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
          case .leftToRight:
              gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
              gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
          case .diagonal:
              gradientLayer.startPoint = CGPoint(x: 0, y: 0)
              gradientLayer.endPoint = CGPoint(x: 1, y: 1)
          }
          
          // إزالة التدرج السابق إن وجد
          layer.sublayers?.removeAll { $0 is CAGradientLayer }
          layer.insertSublayer(gradientLayer, at: 0)
      }
    
    
    func getAllSubviews<T: UIView>(ofType type: T.Type) -> [T] {
        var allSubviews: [T] = []
        
        for subview in subviews {
            if let typedView = subview as? T {
                allSubviews.append(typedView)
            }
            allSubviews.append(contentsOf: subview.getAllSubviews(ofType: type))
        }
        
        return allSubviews
    }

}
