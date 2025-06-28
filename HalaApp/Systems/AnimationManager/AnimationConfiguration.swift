//
//  AnimationConfiguration.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 28/06/2025.
//

import Foundation
import UIKit


// MARK: - Animation Configuration
public struct AnimationConfig {
    
    let duration: TimeInterval
    let delay: TimeInterval
    let dampingRatio: CGFloat
    let initialVelocity: CGFloat
    let options: UIView.AnimationOptions
    let completion: (() -> Void)?

    
    public init(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        dampingRatio: CGFloat = 0.7,
        initialVelocity: CGFloat = 0.5,
        options: UIView.AnimationOptions = .curveEaseInOut,
        completion: (() -> Void)? = nil
    ) {
        self.duration = duration
        self.delay = delay
        self.dampingRatio = dampingRatio
        self.initialVelocity = initialVelocity
        self.options = options
        self.completion = completion
    }

}
