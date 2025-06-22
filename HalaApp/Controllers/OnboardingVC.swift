//
//  OnboardingVC.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 06/06/2025.
//

import UIKit

class OnboardingVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var animitionIMageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datilsLabel: UILabel!
    @IBOutlet weak var imageNextView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!

    // MARK: - Properties
    private var onboardingList: [Onboarding] = Onboarding.onbordings
    private var currentIndex: Int = 0
    private var isAnimating: Bool = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialContent()
        print("✅ عرض واجهة التعريف")
    }
    
    deinit {
        removeThemeObserver()
    }
}

// MARK: - Actions
extension OnboardingVC {
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        handleNextButtonTap()
    }
    
    @objc private func skipViewController() {
        completeOnboarding()
        print("⏭️ تم تخطي التعريف")
    }
}

// MARK: - Navigation Logic
extension OnboardingVC {
    
    private func handleNextButtonTap() {
        guard !isAnimating else { return }
        
        if currentIndex < onboardingList.count - 1 {
            moveToNextOnboarding()
        } else {
            completeOnboarding()
        }
    }
    
    private func moveToNextOnboarding() {
        currentIndex += 1
        updateContent(withAnimation: true)
        updateSkipButtonVisibility()
    }
    
    private func completeOnboarding() {
        UserDefaultsManager.hasCompletedOnboarding = true
        AppNavigationManager.shared.completeOnboarding()
        print("🎉 تم إكمال التعريف")
    }
}

// MARK: - UI Setup
extension OnboardingVC {
    
    private func setupUI() {
        updateUIForCurrentTheme()
        setupLabels()
        setupImages()
        setupButtons()
        hideNavigationBar()
    }
    
    private func setupLabels() {
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        
        datilsLabel.numberOfLines = 0
        datilsLabel.textAlignment = .center
        datilsLabel.lineBreakMode = .byWordWrapping
        datilsLabel.adjustsFontSizeToFitWidth = true
        datilsLabel.minimumScaleFactor = 0.9
    }
    
    private func setupImages() {
        animitionIMageView.contentMode = .scaleAspectFit
        animitionIMageView.clipsToBounds = true
        
        // تدوير السهم حسب اتجاه اللغة
        setupArrowDirection()
    }
    
    private func setupArrowDirection() {
        let isRTL = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
        let rotationAngle: CGFloat = isRTL ? 0 : .pi
        imageNextView.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    private func setupButtons() {
        // إعداد زر التخطي
        skipButton.setupCustomButton(
            title: .skip,
            titleColor: .textSecondary,
            ofSize: .size_14,
            font: .cairo
        )
        skipButton.addTarget(
            self,
            action: #selector(skipViewController),
            for: .touchUpInside
        )
        
        
    }
}

// MARK: - Content Management
extension OnboardingVC {
    
    private func loadInitialContent() {
        updateContent(withAnimation: false)
    }
    
    private func updateContent(withAnimation: Bool) {
        guard currentIndex < onboardingList.count else { return }
        
        let onboarding = onboardingList[currentIndex]
        
        if withAnimation {
            performAnimatedUpdate(with: onboarding)
        } else {
            performStaticUpdate(with: onboarding)
        }
        
        updateSkipButtonVisibility()
    }
    
    private func performAnimatedUpdate(with onboarding: Onboarding) {
        isAnimating = true
        
        // انيميشن الخروج
        UIView.animate(withDuration: 0.3, animations: {
            self.animitionIMageView.alpha = 0
            self.titleLabel.alpha = 0
            self.datilsLabel.alpha = 0
            self.animitionIMageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            // تحديث المحتوى
            self.setContent(with: onboarding)
            
            // انيميشن الدخول
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                self.animitionIMageView.alpha = 1
                self.titleLabel.alpha = 1
                self.datilsLabel.alpha = 1
                self.animitionIMageView.transform = .identity
            }) { _ in
                self.isAnimating = false
                self.animateNextButton()
            }
        }
    }
    
    private func performStaticUpdate(with onboarding: Onboarding) {
        setContent(with: onboarding)
    }
    
    private func setContent(with onboarding: Onboarding) {
        // تحديث الصورة
        animitionIMageView.image = UIImage(named: onboarding.animationName)
        
        // تحديث النصوص
        titleLabel.setupCustomLable(
            text: onboarding.title,
            textColor: .text,
            ofSize: .size_32,
            font: .tajawal , fontStyle: .extraBold,
            alignment: .center
        )
        
        datilsLabel.setupCustomLable(
            text: onboarding.description,
            textColor: .text,
            ofSize: .size_16,
            font: .tajawal , fontStyle: .medium ,
            alignment: .center
        )
    }
    
    private func updateSkipButtonVisibility() {
        let isLastScreen = currentIndex == onboardingList.count - 1
        
        UIView.animate(withDuration: 0.3) {
            self.skipButton.alpha = isLastScreen ? 0 : 1
        }
        
        skipButton.isUserInteractionEnabled = !isLastScreen
    }
    
    private func animateNextButton() {
        // تأثير نبض خفيف للسهم
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .allowUserInteraction) {
            self.imageNextView.transform = self.imageNextView.transform.scaledBy(x: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .allowUserInteraction) {
                let isRTL = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
                let rotationAngle: CGFloat = isRTL ? 0 : .pi
                self.imageNextView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            }
        }
    }
}

// MARK: - Theme Support
extension OnboardingVC {
    
    override func updateUIForCurrentTheme() {
        view.setBackgroundColor(.background)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            DispatchQueue.main.async {
                self.updateUIForCurrentTheme()
            }
        }
    }
}
