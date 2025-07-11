//
//  TableView+Extension.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 09/07/2025.
//

import UIKit

// MARK: - Cell Registration
extension UITableView {
    
    /// تسجيل خلية في الجدول باستخدام النوع العام
    /// السبب: يوفر طريقة آمنة ومبسطة لتسجيل الخلايا المبرمجة بدون XIB
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        let identifier = String(describing: cellType)
        register(cellType, forCellReuseIdentifier: identifier)
    }

    /// تسجيل خلية باستخدام XIB
    /// السبب: يبسط تسجيل الخلايا المصممة بـ XIB مع تجنب الأخطاء في أسماء الملفات
    func registerNib<T: UITableViewCell>(_ cellType: T.Type) {
        let identifier = String(describing: cellType)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }

    /// تسجيل خلية باستخدام Enum مع تعيين delegate و dataSource
    /// السبب: يجمع عدة عمليات في خطوة واحدة - تسجيل الخلية وتعيين المنتدبين
    func registerNib(cellType: TVCells,
                     delegate: UITableViewDelegate? = nil,
                     dataSource: UITableViewDataSource? = nil) {
        let identifier = cellType.rawValue
        
        // تعيين delegate و dataSource
        self.delegate = delegate
        self.dataSource = dataSource
        
        // تسجيل الخلية
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
}

// MARK: - Cell Dequeue
extension UITableView {
    
    /// الحصول على خلية مع النوع العام
    /// السبب: يوفر type safety ويقلل من احتمالية الأخطاء عند casting
    func dequeueCell<T: UITableViewCell>(
        for indexPath: IndexPath,
        cellType: T.Type = T.self
    ) -> T {
        let identifier = String(describing: cellType)
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier: \(identifier)")
        }
        
        return cell
    }
    
    /// الحصول على خلية باستخدام Enum
    /// السبب: يستخدم نظام الـ enum المحدد مسبقاً لضمان الاتساق عبر التطبيق
    func dequeueCell<T: UITableViewCell>(
        for indexPath: IndexPath,
        cellType: TVCells
    ) -> T {
        let identifier = cellType.rawValue
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier: \(identifier)")
        }
        
        return cell
    }
}

// MARK: - Table Configuration
extension UITableView {
    
    /// تهيئة الفواصل بين الخلايا
    /// السبب: يوفر تحكم سهل في مظهر الفواصل دون الحاجة لكتابة الكود المتكرر
    func configureSeparator(
        style: UITableViewCell.SeparatorStyle = .singleLine,
        inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
        color: UIColor? = nil
    ) {
        self.separatorStyle = style
        self.separatorInset = inset
        
        if let color = color {
            self.separatorColor = color
        }
    }
    
    /// تهيئة الجدول بالإعدادات الافتراضية
    /// السبب: يوفر إعدادات موحدة لجميع الجداول في التطبيق مع إمكانية التخصيص
    func configureDefault(backgroundColor: UIColor = .systemBackground,
                          separatorStyle: UITableViewCell.SeparatorStyle = .none,
                          showScrollIndicator: Bool = false,
                          estimatedRowHeight: CGFloat = UITableView.automaticDimension
    ) {
        self.backgroundColor = backgroundColor
        self.separatorStyle = separatorStyle
        self.showsVerticalScrollIndicator = showScrollIndicator
        self.showsHorizontalScrollIndicator = showScrollIndicator
        self.estimatedRowHeight = estimatedRowHeight
        self.rowHeight = UITableView.automaticDimension
        self.tableFooterView = UIView()
    }

    /// تهيئة الجدول مع تسجيل الخلية وتعيين المنتدبين
    /// السبب: يجمع جميع عمليات الإعداد في دالة واحدة لتبسيط عملية التهيئة
    func configureTableView(cellName: TVCells,
                            delegate: UITableViewDelegate? = nil,
                            dataSource: UITableViewDataSource? = nil,
                            applyDefaults: Bool = true
    ) {
        // تطبيق الإعدادات الافتراضية
        if applyDefaults {
            configureDefault()
        }
        
        // تسجيل الخلية
        registerNib(cellType: cellName, delegate: delegate, dataSource: dataSource)
    }
    
    /// تحسين الأداء للجداول الكبيرة
    /// السبب: يطبق إعدادات محسنة للأداء مع الجداول التي تحتوي على بيانات كثيرة
    func optimizeForLargeData() {
        // تقدير ارتفاع الخلايا لتحسين الأداء
        estimatedRowHeight = 80
        estimatedSectionHeaderHeight = 40
        estimatedSectionFooterHeight = 0
        
        // تمكين إعادة الاستخدام للرؤوس والذيول
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        
        // تحسين التمرير
        decelerationRate = UIScrollView.DecelerationRate.fast
    }
}

// MARK: - Scroll Control
extension UITableView {
    
    /// إخفاء أو إظهار مؤشر التمرير العمودي
    /// السبب: يوفر تحكم سهل في مظهر مؤشرات التمرير
    func hideVerticalScrollIndicator(isHidden: Bool = true) {
        self.showsVerticalScrollIndicator = !isHidden
        self.showsHorizontalScrollIndicator = !isHidden
    }

    /// إيقاف التمرير تمامًا
    /// السبب: مفيد عندما تريد عرض محتوى ثابت أو منع المستخدم من التمرير
    func disableScroll() {
        isScrollEnabled = false
    }
    
    /// تمكين التمرير
    /// السبب: لإعادة تمكين التمرير بعد إيقافه
    func enableScroll() {
        isScrollEnabled = true
    }
    
    /// التمرير إلى أعلى الجدول
    /// السبب: مفيد لإعادة المستخدم لأعلى القائمة بحركة سلسة
    func scrollToTop(animated: Bool = true) {
        guard numberOfSections > 0, numberOfRows(inSection: 0) > 0 else { return }
        
        let topIndexPath = IndexPath(row: 0, section: 0)
        scrollToRow(at: topIndexPath, at: .top, animated: animated)
    }
    
    /// التمرير إلى أسفل الجدول
    /// السبب: مفيد لإظهار أحدث المحتويات أو الرسائل الجديدة
    func scrollToBottom(animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        
        let lastSection = numberOfSections - 1
        let lastRow = numberOfRows(inSection: lastSection) - 1
        
        guard lastRow >= 0 else { return }
        
        let bottomIndexPath = IndexPath(row: lastRow, section: lastSection)
        scrollToRow(at: bottomIndexPath, at: .bottom, animated: animated)
    }
}

// MARK: - Data Management
extension UITableView {
    
    /// إعادة تحميل البيانات مع animation
    /// السبب: يوفر تحديث سلس للبيانات مع تأثيرات بصرية جميلة
    func reloadDataWithAnimation(duration: TimeInterval = 0.3) {
        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: {
                              self.reloadData()
                          })
    }
    
    /// التحقق من وجود بيانات في الجدول
    /// السبب: مفيد للتحقق السريع من وجود محتوى قبل تنفيذ عمليات معينة
    func hasData() -> Bool {
        for section in 0..<numberOfSections {
            if numberOfRows(inSection: section) > 0 {
                return true
            }
        }
        return false
    }
    
    /// الحصول على إجمالي عدد الخلايا
    /// السبب: مفيد للإحصائيات أو عند الحاجة لمعرفة العدد الإجمالي للعناصر
    func totalNumberOfRows() -> Int {
        var total = 0
        for section in 0..<numberOfSections {
            total += numberOfRows(inSection: section)
        }
        return total
    }
}

// MARK: - Refresh Control
extension UITableView {
    
    /// إضافة pull to refresh
    /// السبب: يوفر طريقة سهلة لإضافة خاصية السحب للتحديث
    func addPullToRefresh(target: Any?, action: Selector, tintColor: UIColor = .systemBlue) {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = tintColor
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        self.refreshControl = refreshControl
    }

    /// إنهاء حالة التحديث
    /// السبب: لإيقاف مؤشر التحديث بعد انتهاء عملية تحديث البيانات
    func endRefreshing() {
        refreshControl?.endRefreshing()
    }
    
    /// التحقق من حالة التحديث
    /// السبب: للتحقق من حالة refresh control قبل تنفيذ عمليات معينة
    func isRefreshing() -> Bool {
        return refreshControl?.isRefreshing ?? false
    }
}


// MARK: - Visual Effects
extension UITableView {
    
    /// تطبيق تأثير اهتزاز عند الخطأ
    /// السبب: يوفر تفاعل بصري عند حدوث خطأ أو عملية غير صحيحة
    func shake(duration: TimeInterval = 0.6, intensity: CGFloat = 10) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = duration
        animation.values = [-intensity, intensity, -intensity, intensity, -intensity/2, intensity/2, -intensity/4, intensity/4, 0]
        layer.add(animation, forKey: "shake")
    }
    
    /// إضافة تأثير fade in للجدول
    /// السبب: يوفر انتقال سلس عند ظهور الجدول لأول مرة
    func fadeIn(duration: TimeInterval = 0.3) {
        alpha = 0
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        }
    }
    
    /// إضافة تأثير slide من الأسفل
    /// السبب: يوفر تأثير بصري جذاب عند ظهور الجدول
    func slideInFromBottom(duration: TimeInterval = 0.5) {
        let originalTransform = transform
        transform = CGAffineTransform(translationX: 0, y: frame.height)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.transform = originalTransform
        }
    }
}
