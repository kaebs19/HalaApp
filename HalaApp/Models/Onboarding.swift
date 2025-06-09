//
//  Onboarding.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 09/06/2025.
//

import Foundation

import UIKit

struct Onboarding {
    
    let animationName: String
    let title: String
    let description: String
    
    static let onbordings: [Onboarding] = [
        Onboarding(
            animationName: "Ovals_0",
            title: "دردشة فورية",
            description: "تواصل مع أشخاص جدد عبر رسائل مباشرة تتيح لك التعبير عن نفسك بحرية وتكوين صداقات جديدة في جو من الخصوصية والأمان"
        ),
        Onboarding(
            animationName: "Ovals_1",
            title: "تكوين صداقات",
            description: "استمتع بالتعرف على أشخاص جدد يشاركونك اهتماماتك، وابدأ صداقات حقيقية في عالم افتراضي آمن ومميز"
        ),
        Onboarding(
            animationName: "Ovals_2",
            title: "استكشف اللحظات",
            description: "شارك أجمل لحظاتك وتابع قصص الآخرين في جدول زمني مميز يتيح لك التفاعل والتعرف على أشخاص يشاركونك نفس الاهتمامات"
        ),
        Onboarding(
            animationName: "Ovals_3",
            title: "اكتشف عالمًا جديدًا",
            description: "تصفح ملفات شخصية متنوعة واكتشف أشخاصًا مميزين من مختلف أنحاء العالم، واجعل حياتك أكثر إثارة مع صداقات وعلاقات جديدة"
        )
    ]
}
