//
//  Constraint+Extension.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 11/07/2025.
//

import UIKit

extension NSLayoutConstraint {
    func setPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
