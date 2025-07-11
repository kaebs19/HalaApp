//
//  SettingsCells.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 11/07/2025.
//

import UIKit

class SettingsCells: UITableViewCell {
    
    // MARK: - UI Elements (بدون @IBOutlet)
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
    private let accessoryImageView = UIImageView()
    private let switchControl = UISwitch()
    private let segmentedControl = UISegmentedControl()
    private let separatorView = UIView()
    
    // MARK: - Properties
    private var currentItem: SettingItem?
    
    // MARK: - Constraints Properties
    private var iconCenterYConstraint: NSLayoutConstraint!
    private var titleCenterYConstraint: NSLayoutConstraint!
    private var titleTopConstraint: NSLayoutConstraint!

    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
        
        
    }
}

// MARK: - UI Setup
extension SettingsCells {
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // إضافة جميع العناصر للـ contentView
        [titleLabel, iconImageView, accessoryImageView,
         switchControl, segmentedControl, separatorView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupIconImageView()
        setupTitleLabel()
        setupAccessoryImageView()
        setupSwitchControl()
        setupSegmentedControl()
        setupSeparatorView()
    }
    
    private func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = AppColors.text.color
    }
    
    private func setupAccessoryImageView() {
        accessoryImageView.contentMode = .scaleAspectFit
        accessoryImageView.isHidden = true
    }
    
    private func setupSwitchControl() {
        switchControl.onTintColor = AppColors.primary.color
        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        switchControl.isHidden = true
    }
    
    private func setupSegmentedControl() {
        segmentedControl.backgroundColor = AppColors.secondBackground.color
        segmentedControl.selectedSegmentTintColor = AppColors.primary.color
        
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: AppColors.textSecondary.color,
            .font: FontManager.shared.fontApp(family: .cairo, style: .bold, size: .size_14)
        ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: FontManager.shared.fontApp(family: .cairo, style: .semiBold, size: .size_14)
        ], for: .selected)
        
        
        segmentedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        segmentedControl.isHidden = true
    }
    
    private func setupSeparatorView() {
        separatorView.backgroundColor = AppColors.separator.color
    }
}

// MARK: - Auto Layout Constraints

extension SettingsCells {
    
    private func setupConstraints() {
        
        // 📍 1. أيقونة (الجانب الأيسر)
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        iconCenterYConstraint = iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        let iconTopConstraint = iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18)
        iconTopConstraint.priority = UILayoutPriority(999)
        iconTopConstraint.isActive = true
        
        // 📍 2. العنوان (بجانب الأيقونة) - محسن
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            // ✅ تحسين: priority أقل للـ trailing constraints لتجنب التضارب
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: switchControl.leadingAnchor, constant: -8).setPriority(.defaultHigh),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: accessoryImageView.leadingAnchor, constant: -8).setPriority(.defaultHigh),
            // ✅ إضافة: trailing آمن للـ contentView
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16).setPriority(.required)
        ])
        
        titleCenterYConstraint = titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor)
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        titleTopConstraint.priority = UILayoutPriority(998)
        
        // 📍 3. Switch Control (الجانب الأيمن)
        NSLayoutConstraint.activate([
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor)
        ])
        
        // 📍 4. Accessory Image (سهم التنقل)
        NSLayoutConstraint.activate([
            accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            accessoryImageView.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 16),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        // 📍 5. Segmented Control (تحت العنوان)
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        // 📍 6. الفاصل (أسفل الخلية)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        setupDynamicHeight()
    }

    private func setupDynamicHeight() {
        // ✅ إصلاح: ارتفاع أدنى مرن
        let minHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        minHeightConstraint.priority = UILayoutPriority(900) // أولوية أقل
        minHeightConstraint.isActive = true
        
        // ✅ إصلاح: مسافة من أسفل العناصر
        let iconBottomConstraint = iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -18)
        iconBottomConstraint.priority = UILayoutPriority(950)
        iconBottomConstraint.isActive = true
        
        // للخلايا مع Segmented Control
        let segmentedBottomConstraint = segmentedControl.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        segmentedBottomConstraint.priority = UILayoutPriority(999)
        segmentedBottomConstraint.isActive = true
    }
}


// MARK: - Configuration
extension SettingsCells {
    
    func configure(with item: SettingItem) {
        currentItem = item
        
        // تكوين العنوان
        
        titleLabel.setupCustomLable(text: item.title.titleName,
                                    textColor: .text,
                                    ofSize: .size_16 ,
                                    alignment: .auto)
        
        // تكوين الأيقونة
        iconImageView.image = ImageManager.image(item.icon)
        iconImageView.tintColor = item.tintColor.color
        
        // تكوين العناصر حسب النوع
        configureAccessories(for: item)
        
        updateConstraintsForContent(hasSegmented: item.hasSegmentedControl)
        
        

    }
    
    private func updateConstraintsForContent(hasSegmented: Bool) {
           if hasSegmented {
               // للخلايا مع Segmented Control
               iconCenterYConstraint.isActive = false
               titleCenterYConstraint.isActive = false
               titleTopConstraint.isActive = true
               
               // ✅ إخفاء السهم تماماً للخلايا مع Segmented Control
               accessoryImageView.isHidden = true

           } else {
               // للخلايا العادية
               titleTopConstraint.isActive = false
               iconCenterYConstraint.isActive = true
               titleCenterYConstraint.isActive = true
           }
        
        
       }
    
    private func configureAccessories(for item: SettingItem) {
        // إخفاء جميع العناصر أولاً
        accessoryImageView.isHidden = true
        switchControl.isHidden = true
        segmentedControl.isHidden = true
        
        switch item.actionType {
        case .navigate:
            showNavigationAccessory()
            
        case .toggle:
            showSwitchControl(isOn: item.switchOn)
            
        case .segmented:
            showSegmentedControl(for: item)
            
        case .custom:
            showNavigationAccessory()
        }
    }

    
    // MARK: - Accessory Configuration Methods
    private func showNavigationAccessory() {
        accessoryImageView.isHidden = false
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        accessoryImageView.image = UIImage(systemName: "chevron.right", withConfiguration: config)
        accessoryImageView.tintColor = AppColors.textSecondary.color
    }
    
    private func showSwitchControl(isOn: Bool) {
        switchControl.isHidden = false
        switchControl.isOn = isOn
    }
    
    private func showSegmentedControl(for item: SettingItem) {
        segmentedControl.isHidden = false
        configureSegmentedControlContent(for: item)
    }
    
    private func configureSegmentedControlContent(for item: SettingItem) {
        segmentedControl.removeAllSegments()
        
        switch item.title {
        case .language:
            addLanguageSegments()
            
        case .appearance:
            addThemeSegments()
            
        default:
            break
        }
    }
    
    private func addLanguageSegments() {
        segmentedControl.insertSegment(withTitle: "العربية", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "English", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "النظام", at: 2, animated: false)
        segmentedControl.selectedSegmentIndex = getCurrentLanguageIndex()
    }
    
    private func addThemeSegments() {
        segmentedControl.insertSegment(withTitle: "عادي", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "مظلم", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "تلقائي", at: 2, animated: false)
        segmentedControl.selectedSegmentIndex = getCurrentThemeIndex()
    }
    
    // MARK: - Helper Methods
    private func getCurrentLanguageIndex() -> Int {
        // TODO: استرجاع اللغة الحالية من LanguageManager
        return 0 // العربية افتراضياً
    }
    
    private func getCurrentThemeIndex() -> Int {
        let currentTheme = ThemeManager.shared.currentTheme
        switch currentTheme {
        case .light: return 0
        case .dark: return 1
        case .auto: return 2
        }
    }
    
    private func resetCell() {
        titleLabel.text = nil
        iconImageView.image = nil
        iconImageView.tintColor = AppColors.text.color
        accessoryImageView.isHidden = true
        switchControl.isHidden = true
        segmentedControl.isHidden = true
        currentItem = nil
        
        // إعادة تعيين الـ constraints
        iconCenterYConstraint.isActive = false
        titleCenterYConstraint.isActive = false
        titleTopConstraint.isActive = false

    }
}

// MARK: - Actions
extension SettingsCells {
    
    @objc private func switchValueChanged() {
        guard let item = currentItem else { return }
        print("🔄 Switch تغيرت لـ \(item.title.titleName): \(switchControl.isOn)")
        
        // هنا ستكون معالجة تغيير Switch
        handleSwitchChange(for: item.title, isOn: switchControl.isOn)
    }
    
    @objc private func segmentValueChanged() {
        guard let item = currentItem else { return }
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        switch item.title {
        case .language:
            handleLanguageChange(selectedIndex: selectedIndex)
            
        case .appearance:
            handleThemeChange(selectedIndex: selectedIndex)
            
        default:
            break
        }
    }
    
    // MARK: - Change Handlers
    private func handleSwitchChange(for title: SettingTitle, isOn: Bool) {
        switch title {
        case .notification:
            print("🔔 الإشعارات: \(isOn ? "مفعلة" : "معطلة")")
            // TODO: حفظ إعداد الإشعارات
            
        default:
            print("🔄 تبديل \(title.titleName): \(isOn)")
        }
    }
    
    private func handleLanguageChange(selectedIndex: Int) {
        let languages = ["العربية", "English", "النظام"]
        print("🌐 تم تغيير اللغة إلى: \(languages[selectedIndex])")
        
        // TODO: تطبيق تغيير اللغة
        // LanguageManager.shared.changeLanguage(to: selectedIndex)
    }
    
    private func handleThemeChange(selectedIndex: Int) {
        let themes = ["عادي", "مظلم", "تلقائي"]
        print("🎨 تم تغيير الثيم إلى: \(themes[selectedIndex])")
        
        // تطبيق الثيم الجديد فوراً
        let newTheme: ThemeManager.ThemeMode = [.light, .dark, .auto][selectedIndex]
        ThemeManager.shared.changeTheme(to: newTheme)
    }
}
