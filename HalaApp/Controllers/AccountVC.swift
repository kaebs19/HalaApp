//
//  AccountVC.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 29/06/2025.
//

import UIKit

class AccountVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var placebolderImageView: UIImageView!     // صورة خلفية أو placeholder
    @IBOutlet weak var statusImageView: UIImageView!          // أيقونة حالة المستخدم
    @IBOutlet weak var nameLabel: UILabel!                    // اسم المستخدم
    @IBOutlet weak var prifileImageView: UIImageView!         // أيقونة ثابتة للمستخدم
    @IBOutlet weak var rankLabel: UILabel!                    // رتبة المستخدم
    @IBOutlet weak var accountTableView: UITableView!
    
    // MARK: - Properties
    private var currentUserStatus: UserStatus = UserStatusManager.currentStatus
    private var currentUserRank: UserRank = UserRankManager.currentRank
    private var isLayoutSetup = false // لتجنب إعادة إعداد التخطيط

    private var accountItems: [AccountItem] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()      // ✅ إضافة مراقبي الأحداث
        loadUserData()        // ✅ تحميل البيانات
        
        loadAccountData()
        
        // للاختبار - يمكن إزالتها في الإنتاج
        #if DEBUG
        setupTestData()
        debugSystemInfo()
        #endif
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // تحديث الأشكال الدائرية مرة واحدة فقط
        if !isLayoutSetup {
            updateCircularShapes()
            isLayoutSetup = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanup()
    }
    
    deinit {
        cleanup()
    }
}

// MARK: - Setup Methods
extension AccountVC {
    
    /// إعداد الواجهة الأساسية
    private func setupUI() {
        // تطبيق التجاوب للشاشات المختلفة
        makeResponsive()
        
        // إعداد شريط التنقل
        setNavigationButtons(items: [], title: .account, isLargeTitle: true)
        
        // إعداد لون الخلفية
        view.setBackgroundColor(.background)
        
        // إعداد مراقب تغييرات الثيم
        setupThemeObserver()
        
        // ✅ إعداد جميع العناصر
        setupViews()
        setupLabels()
        setupImages()
        setupInteractions()
        
        // اعدادات tableView
        setupTableView()
    }
    
    private func setupViews() {
        // تطبيق التحديث الأولي للثيم
        updateUIForCurrentTheme()
    }
    
    private func setupLabels() {
        // إعداد label الاسم - يكون بارز ومميز
        nameLabel.setupCustomLable(
            text: getUserDisplayName(),
            textColor: .text,
            ofSize: .size_24,
            font: .cairo,
            fontStyle: .bold,
            alignment: .auto,
            numberOfLines: 1,
            responsive: true
        )
        
        // إعداد label الرتبة مع الألوان والتصميم
        setupRankLabel()
    }
    
    private func setupRankLabel() {
        // النص الأساسي للرتبة
        rankLabel.setupCustomLable(
            text: currentUserRank.displayName,
            textColor: .text,
            ofSize: .size_20,
            font: .cairo,
            fontStyle: .semiBold,
            alignment: .auto,
            numberOfLines: 1,
            responsive: true
        )
        
        // إضافة خلفية ملونة للرتبة
        rankLabel.backgroundColor = currentUserRank.backgroundColor
        rankLabel.textColor = currentUserRank.color
        
        // تنسيق الشكل
        rankLabel.layer.cornerRadius = 8
        rankLabel.layer.masksToBounds = true
        
        // إضافة حدود خفيفة
        rankLabel.layer.borderWidth = 1
        rankLabel.layer.borderColor = currentUserRank.color.withAlphaComponent(0.3).cgColor
        
        // ✅ إضافة المسافات الداخلية
       // rankLabel.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    }
    
    private func setupImages() {
        // إعداد صورة المستخدم الرئيسية (placeholder)
        setupPlaceholderImage()
        
        // إعداد أيقونة الحالة
        setupStatusImage()
        
        // إعداد أيقونة الملف الشخصي الثابتة
        setupProfileIcon()
    }
    
    /// إعداد صورة المستخدم الأساسية
    private func setupPlaceholderImage() {
        // صورة افتراضية للمستخدم
        placebolderImageView.image = UIImage(systemName: "person.circle.fill")
        placebolderImageView.tintColor = AppColors.textSecondary.color
        placebolderImageView.contentMode = .scaleAspectFill
        
        // الشكل والحدود سيتم تطبيقها في viewDidLayoutSubviews
    }

    /// إعداد أيقونة الحالة
    private func setupStatusImage() {
        // إضافة حدود بيضاء لتمييز الأيقونة
        statusImageView.layer.borderWidth = 2
        statusImageView.layer.borderColor = UIColor.white.cgColor
        
        // تحديث أيقونة الحالة
        updateStatusImage()
        
        // إضافة إيماءة للتفاعل مع الحالة
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(statusImageTapped))
        statusImageView.addGestureRecognizer(tapGesture)
        statusImageView.isUserInteractionEnabled = true
    }
    
    /// إعداد أيقونة الملف الشخصي الثابتة
    private func setupProfileIcon() {
        // أيقونة ثابتة تدل على نوع المستخدم أو الرتبة
        if let iconImage = UIImage(systemName: currentUserRank.icon) {
            prifileImageView.image = iconImage
            prifileImageView.tintColor = currentUserRank.color
        } else {
            // أيقونة افتراضية
            prifileImageView.image = UIImage(systemName: "person.fill")
            prifileImageView.tintColor = AppColors.primary.color
        }
        
        // تنسيق الأيقونة
        prifileImageView.contentMode = .scaleAspectFit
    }
    
    /// إعداد التفاعلات
    private func setupInteractions() {
        // إضافة إيماءة لتغيير الرتبة (للاختبار)
        let rankTapGesture = UITapGestureRecognizer(target: self, action: #selector(rankLabelTapped))
        rankLabel.addGestureRecognizer(rankTapGesture)
        rankLabel.isUserInteractionEnabled = true
        
        // إضافة إيماءة للاسم لإظهار تفاصيل إضافية
        let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(nameLabelTapped))
        nameLabel.addGestureRecognizer(nameTapGesture)
        nameLabel.isUserInteractionEnabled = true
    }
}

// MARK: - Data Loading & Updates
extension AccountVC {

    /// تحميل بيانات المستخدم
    private func loadUserData() {
        // تحديث البيانات من المصادر المحفوظة
        currentUserStatus = UserStatusManager.currentStatus
        currentUserRank = UserRankManager.currentRank
        
        // تحديث الواجهة
        updateUserInterface()

        print("📊 تم تحميل بيانات المستخدم:")
        print("   - الاسم: \(getUserDisplayName())")
        print("   - الحالة: \(currentUserStatus.displayName)")
        print("   - الرتبة: \(currentUserRank.displayName)")
        print("   - النقاط: \(UserRankManager.userPoints)")
    }
    
    /// تحديث واجهة المستخدم
    private func updateUserInterface() {
        // تحديث الاسم
        nameLabel.text = getUserDisplayName()
        
        // تحديث الحالة
        updateStatusImage()
        
        // تحديث الرتبة
        updateRankDisplay()
        
        // تحديث الأيقونة الثابتة
        updateProfileIcon()
    }
    
    /// تحديث عرض أيقونة الحالة
    private func updateStatusImage() {
        // تطبيق لون الحالة على الخلفية
        statusImageView.backgroundColor = currentUserStatus.color
        
        // إضافة أيقونة أو نقطة للحالة
        statusImageView.image = currentUserStatus.statusIcon
        statusImageView.tintColor = .white
        
        print("🔄 تم تحديث حالة المستخدم إلى: \(currentUserStatus.displayName)")
    }
    
    /// تحديث عرض الرتبة
    private func updateRankDisplay() {
        // تحديث النص
        rankLabel.text = currentUserRank.displayName
        
        // تحديث الألوان
        rankLabel.textColor = currentUserRank.color
        rankLabel.backgroundColor = currentUserRank.backgroundColor
        rankLabel.layer.borderColor = currentUserRank.color.withAlphaComponent(0.3).cgColor
        
        print("🏆 تم تحديث رتبة المستخدم إلى: \(currentUserRank.displayName)")
    }
    
    /// تحديث الأيقونة الثابتة
    private func updateProfileIcon() {
        if let iconImage = UIImage(systemName: currentUserRank.icon) {
            prifileImageView.image = iconImage
            prifileImageView.tintColor = currentUserRank.color
        }
    }
    
    /// الحصول على اسم المستخدم للعرض
    private func getUserDisplayName() -> String {
        return UserDefaultsManager.userName ?? "مستخدم الهلا"
    }
}

// MARK: - Observers & Notifications
extension AccountVC {
    
    /// إعداد مراقبي الأحداث
    private func setupObservers() {
        // مراقب تغيير الحالة
        NotificationCenter.default.addObserver(
            forName: .userStatusDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let newStatus = notification.object as? UserStatus {
                self?.currentUserStatus = newStatus
                self?.updateStatusImage()
            }
        }
        
        // مراقب تغيير الرتبة
        NotificationCenter.default.addObserver(
            forName: .userRankDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let newRank = notification.object as? UserRank {
                self?.currentUserRank = newRank
                self?.updateRankDisplay()
                self?.updateProfileIcon()
            }
        }

        // مراقب ترقية الرتبة (مع تأثيرات خاصة)
        NotificationCenter.default.addObserver(
            forName: .userRankUpgraded,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleRankUpgrade(notification)
        }
    }
    
    /// معالج ترقية الرتبة مع تأثيرات بصرية
    private func handleRankUpgrade(_ notification: Notification) {
        guard let newRank = notification.object as? UserRank,
              let userInfo = notification.userInfo,
              let oldRank = userInfo["oldRank"] as? UserRank else { return }
        
        // تأثير اهتزاز للاحتفال
        HapticManager.shared.successImpact()
        
        // تأثير بصري للرتبة
        UIView.animate(withDuration: 0.3, animations: {
            self.rankLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.rankLabel.transform = .identity
            }
        }
        
        // إشعار بالترقية
        NativeMessagesManager.shared.showSuccess(
            title: "🎉 مبروك الترقية!",
            message: "تم ترقيتك من \(oldRank.displayName) إلى \(newRank.displayName)"
        )
        
        print("🎊 تم الاحتفال بترقية الرتبة!")
    }
}

// MARK: - User Interactions
extension AccountVC {
    
    /// التفاعل مع أيقونة الحالة - تغيير الحالة
    @objc private func statusImageTapped() {
        print("👆 تم الضغط على أيقونة الحالة")
        
        // تأثير اهتزاز خفيف
        HapticManager.shared.lightImpact()
        
        // تغيير للحالة التالية
        UserStatusManager.shared.toggleToNextStatus()
        
        // تأثير بصري
        UIView.animate(withDuration: 0.2, animations: {
            self.statusImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.statusImageView.transform = .identity
            }
        }
    }

    /// التفاعل مع الرتبة - إضافة نقاط (للاختبار)
    @objc private func rankLabelTapped() {
        print("👆 تم الضغط على رتبة المستخدم")
        
        // إضافة نقاط للاختبار
        let pointsToAdd = Int.random(in: 50...200)
        UserRankManager.shared.addPoints(pointsToAdd)
        
        // تأثير اهتزاز
        HapticManager.shared.mediumImpact()
        
        // رسالة إضافة النقاط
        NativeMessagesManager.shared.showSimpleSuccess(
            "تم إضافة \(pointsToAdd) نقطة!",
            message: "المجموع الآن: \(UserRankManager.userPoints)"
        )
    }

    /// التفاعل مع الاسم - إظهار معلومات المستخدم
    @objc private func nameLabelTapped() {
        print("👆 تم الضغط على اسم المستخدم")
        
        // تأثير اهتزاز خفيف
        HapticManager.shared.lightImpact()
        
        // إظهار معلومات تفصيلية
        showUserDetails()
    }

    /// عرض تفاصيل المستخدم
    private func showUserDetails() {
        let userInfo = """
        👤 \(getUserDisplayName())
        📊 الحالة: \(currentUserStatus.displayName)
        🏆 الرتبة: \(currentUserRank.displayName)
        ⭐ النقاط: \(UserRankManager.userPoints)
        """
        
        if let pointsToNext = UserRankManager.shared.pointsToNextRank() {
            let progress = UserRankManager.shared.progressToNextRank()
            let progressPercentage = Int(progress * 100)
            
            let detailedInfo = userInfo + """
            
            📈 التقدم للرتبة التالية: \(progressPercentage)%
            🎯 نقاط مطلوبة: \(pointsToNext)
            """
            
            NativeMessagesManager.shared.showInfo(
                title: "معلومات المستخدم",
                message: detailedInfo
            )
        } else {
            NativeMessagesManager.shared.showInfo(
                title: "معلومات المستخدم",
                message: userInfo + "\n\n🎉 وصلت لأعلى رتبة!"
            )
        }
    }
}

// MARK: - Layout Helpers
extension AccountVC {
    
    /// تحديث الأشكال الدائرية
    private func updateCircularShapes() {
        // تحديث صورة المستخدم الرئيسية
        placebolderImageView.layer.cornerRadius = placebolderImageView.frame.width / 2
        placebolderImageView.layer.masksToBounds = true
        
        // إضافة حدود وظل لصورة المستخدم
        placebolderImageView.layer.borderWidth = 3
        placebolderImageView.layer.borderColor = AppColors.primary.color.cgColor
        
        placebolderImageView.setShadow(
            color: .primary,
            offset: CGSize(width: 0, height: 4),
            radius: 8,
            opacity: 0.3
        )
        
        // تحديث أيقونة الحالة
        statusImageView.layer.cornerRadius = statusImageView.frame.width / 2
        statusImageView.layer.masksToBounds = true
        
        print("🔄 تم تحديث الأشكال الدائرية")
    }
}

// MARK: - Theme Support
extension AccountVC {
    
    private func cleanup() {
        removeThemeObserver()
        NativeMessagesManager.shared.hideAll()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func updateUIForCurrentTheme() {
        view.setBackgroundColor(.background)
        
        // تحديث ألوان النصوص
        nameLabel.textColor = AppColors.text.color
        
        // تحديث حدود الصور
        placebolderImageView.layer.borderColor = AppColors.primary.color.cgColor
        
        // تحديث الرتبة (مع الحفاظ على ألوانها الخاصة)
        updateRankDisplay()
        
        print("🎨 تم تحديث الواجهة حسب الثيم الحالي")
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

// MARK: - Debug & Testing Methods
extension AccountVC {
    
    /// إعداد بيانات تجريبية للاختبار
    private func setupTestData() {
        // بيانات تجريبية - يمكن استخدامها أثناء التطوير
        UserDefaultsManager.userName = "أحمد محمد الهلا"
        UserRankManager.userPoints = 750 // سيضعه في رتبة "مستخدم عادي"
        UserStatusManager.currentStatus = .available
        
        print("🧪 تم تطبيق البيانات التجريبية")
    }
    
    /// طباعة معلومات النظام للتشخيص
    private func debugSystemInfo() {
        print("🔍 معلومات النظام:")
        print("================")
        print("الاسم: \(getUserDisplayName())")
        print("الحالة: \(currentUserStatus.displayName)")
        print("الرتبة: \(currentUserRank.displayName)")
        print("النقاط: \(UserRankManager.userPoints)")
        
        if let pointsToNext = UserRankManager.shared.pointsToNextRank() {
            print("نقاط للرتبة التالية: \(pointsToNext)")
        } else {
            print("الرتبة: أعلى رتبة")
        }
        
        print("التقدم: \(Int(UserRankManager.shared.progressToNextRank() * 100))%")
        print("================")
    }
}


extension AccountVC {
    
    private func setupTableView() {
        accountTableView.registerNib(cellType: .accountCell ,
                                     delegate: self ,
                                     dataSource: self)
        accountTableView.hideVerticalScrollIndicator()
        accountTableView.configureSeparator(inset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    private func loadAccountData() {
        // ✅ تحميل البيانات من AccountDataManager
        accountItems = AccountDataManager.shared.getAllItems()
        accountTableView.reloadData()

    }
    
}


extension AccountVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = accountItems[indexPath.row]
        
        if let cell = tableView.cellForRow(at: indexPath) as? AccountsCells {
            cell.animateSelection()
        }
        
        HapticManager.shared.lightImpact()
        
        // الانتقال حسب النوع
        navigateToScreen(for: item.type)

    }
}

extension AccountVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCell(for: indexPath ,cellType: AccountsCells.self)
        cell.configure(with: accountItems[indexPath.row])
        
        return cell
    }
    
    
}

// MARK: - Navigation Methods

extension AccountVC {
    
    
    private func navigateToScreen(for type: AccountType) {
        switch type {
        case .subscriptions:
            print("🔗 الاشتراكات")
            goToSubscriptions()
            
        case .nearby:
            print("📍 الأشخاص القريبون")
            goToNearbyPeople()
            
        case .favorites:
            print("⭐ محفظتي")
            goToWallet()
            
        case .shareProfile:
            print("📤 رمز QR")
            goToQRCode()
            
        case .settings:
            print("⚙️ الإعدادات")
            goToSettings()
        }
    }
    
    // MARK: - Individual Navigation Methods
    private func goToSubscriptions() {
        showComingSoon(for: "الاشتراكات")
    }
    
    private func goToNearbyPeople() {
        showComingSoon(for: "الأشخاص القريبون")
    }
    
    private func goToWallet() {
        showComingSoon(for: "محفظتي")
    }
    
    private func goToQRCode() {
        goToVC(
            storyboard: .Main,
            identifiers: .MyQRCodeVC,
            navigationStyle: .present(animated: true)
        )
    }
    
    private func goToSettings() {
        goToVC(
            storyboard: .Main,
            identifiers: .Settings,
            navigationStyle: .present(animated: true)
        )
    }
    
    private func showComingSoon(for feature: String) {
        NativeMessagesManager.shared.showInfo(
            title: "قريباً",
            message: "ميزة \(feature) ستكون متاحة قريباً!"
        )
    }

}
