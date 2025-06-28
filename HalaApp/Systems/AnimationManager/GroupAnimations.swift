//
//  GroupAnimations.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 28/06/2025.
//

import UIKit


// MARK: - Group Animations
extension AnimationManager {
    
    /// أنيميشن متتالي لعدة views
    public func cascade(
        views: [UIView],
        type: AnimationType,
        delay: TimeInterval = 0.1,
        config: AnimationConfig = Defaults.normal
    ) {
        for (index, view) in views.enumerated() {
            let delayedConfig = AnimationConfig(
                duration: config.duration,
                delay: config.delay + (Double(index) * delay),
                dampingRatio: config.dampingRatio,
                initialVelocity: config.initialVelocity,
                options: config.options,
                completion: index == views.count - 1 ? config.completion : nil
            )
            
            animate(view: view, type: type, config: delayedConfig)
        }
    }
    
    /// أنيميشن متوازي لعدة views
    public func parallel(
        views: [UIView],
        type: AnimationType,
        config: AnimationConfig = Defaults.normal
    ) {
        views.forEach { view in
            animate(view: view, type: type, config: config)
        }
    }
}
