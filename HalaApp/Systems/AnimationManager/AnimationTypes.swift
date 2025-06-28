//
//  AnimationTypes.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 28/06/2025.
//


import UIKit

// MARK: - Animation Types
public enum AnimationType {
    case fadeIn
    case fadeOut
    case slideIn(direction: SlideDirection)
    case slideOut(direction: SlideDirection)
    case scale(from: CGFloat, to: CGFloat)
    case bounce
    case shake
    case pulse
    case flip(axis: FlipAxis)
    case rotate(angle: CGFloat)
    case spring
    case wobble
    case flash
    case ripple
}

public enum SlideDirection {
    case left, right, up, down
}

public enum FlipAxis {
    case horizontal, vertical
}

/*
🎨 أنواع الأنيميشنز المتاحة
الأنيميشنز الأساسية

.fadeIn - ظهور تدريجي
.fadeOut - اختفاء تدريجي
.scale(from:to:) - تغيير الحجم
.bounce - ارتداد
.shake - اهتزاز
.pulse - نبض
.rotate(angle:) - دوران

أنيميشنز الانزلاق

.slideIn(direction:) - انزلاق للداخل
.slideOut(direction:) - انزلاق للخارج

أنيميشنز متقدمة

.flip(axis:) - قلب
.spring - نابض
.wobble - هز
.flash - وميض
.ripple - تموج

 */
