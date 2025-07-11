//
//  SettingsVC.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 11/07/2025.
//

import UIKit

class SettingsVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var haderView: UIView!
    @IBOutlet weak var tileLabel: UILabel!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var logoutImageView: UIImageView!
    
    // MARK: - Properties
    var settingItems: [SettingItem] = []
    private var settingSections: [SettingsSection] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        loadSettingsData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanup()
    }

    deinit {
        cleanup()
    }

}

extension SettingsVC {
    
    /// إعداد الواجهة الأساسية
    private func setupUI() {
        // تطبيق التجاوب للشاشات المختلفة
        makeResponsive()
        
        // إعداد شريط التنقل
        setNavigationButtons(items: [.closeIcon], title: .settings)
        
        // إعداد لون الخلفية
        view.setBackgroundColor(.background)
        
        // إعداد مراقب تغييرات الثيم
        setupThemeObserver()
        
        setupTableView(with: settingsTableView)
        setupLables()
        setupButtons()
        setupViews()
    }
    
    private func setupViews() {
        haderView.backgroundColor = .appColor(.secondBackground)
        logoutView.backgroundColor = .appColor(.background)
    }
    
    private func setupLables() {
        tileLabel.setupCustomLable(text: Title.settings.TextTitle,
                                   textColor: .text,
                                   ofSize: .size_16 ,
                                   fontStyle: .bold ,
                                   alignment: .center,
                                   responsive: true)
        
        logoutLabel.setupCustomLable(text: Lables.Logout.textName,
                                     textColor: .onlyRed,
                                     ofSize: .size_14,
                                     fontStyle: .bold,
                                     responsive: true)
        
    }
    
    private func setupButtons() {
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    @objc func logoutTapped() {
        print("🚪 Logout Tapped")
        // هنا ستكون دالة تسجيل الخروج
    }
    
    private func setupTableView(with tableView: UITableView) {
        
        tableView.register(SettingsCells.self)
        tableView.delegate = self
        tableView.dataSource = self
        // إعدادات إضافية
        tableView.backgroundColor = .clear
        tableView.configureSeparator(inset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        tableView.hideVerticalScrollIndicator()
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension

    }
    
    // MARK: - Data Loading
    private func loadSettingsData() {
        settingSections = SettingsDataManager.shared.getAllSections()
        settingItems = SettingsDataManager.shared.getAllSettings() // للتوافق
        settingsTableView.reloadData()

    }
}



extension SettingsVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          let item = settingSections[indexPath.section].items[indexPath.row]
          return item.hasSegmentedControl ? 80 : 60
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let item = settingSections[indexPath.section].items[indexPath.row]
          
          HapticManager.shared.lightImpact()
          handleSettingAction(item, at: indexPath)
      }
      
      // MARK: - Headers & Footers
      func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return section == 0 ? 0 : 20 // مسافة بين الأقسام
      }
      
      func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          return 0.01 // الحد الأدنى
      }
      
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          if section == 0 {
              return nil
          }
          
          // إنشاء view فارغ للمسافة بين الأقسام
          let headerView = UIView()
          headerView.backgroundColor = .clear
          return headerView
      }
      
      func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
          let footerView = UIView()
          footerView.backgroundColor = .clear
          return footerView
      }
    
    private func handleSettingAction(_ item: SettingItem , at indexPath: IndexPath) {
        
        switch item.actionType {
                
            case .navigate:
                print("🔗 الانتقال إلى: \(item.title.titleName)")

            case .toggle:
                print("🔄 تبديل: \(item.title.titleName)")

            case .segmented:
                print("📊 Segmented Control: \(item.title.titleName)")
                // لا نفعل شيء هنا لأن التفاعل يتم مع الـ Segmented Control مباشرة

            case .custom(let action):
                action(self)
        }
    }
    
}

extension SettingsVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return settingSections.count
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return settingSections[section].items.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCells", for: indexPath) as! SettingsCells
         let item = settingSections[indexPath.section].items[indexPath.row]
         
         cell.configure(with: item)
         return cell
     }
    
    
}



// MARK: - Theme Support
extension SettingsVC {
    
    private func cleanup() {
        removeThemeObserver()
        NativeMessagesManager.shared.hideAll()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func updateUIForCurrentTheme() {
        view.setBackgroundColor(.background)
        haderView.backgroundColor = .appColor(.secondBackground)
        logoutView.backgroundColor = .appColor(.background)

        // تحديث ألوان النصوص
        logoutLabel.textColor = .appColor(.text)
        
        // تحديث أيقونة تسجيل الخروج
        logoutImageView.image = ImageManager.image(.logout)
        logoutImageView.tintColor = .appColor(.onlyRed)
        
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

