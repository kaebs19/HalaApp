//
//  AccountsCells.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 10/07/2025.
//

import UIKit

class AccountsCells: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension AccountsCells {
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    func configure(with item: AccountItem) {
        nameLabel.setupCustomLable(text: item.type.displayName,
                                   textColor: .text,
                                   ofSize: .size_14 ,
                                   fontStyle: .semiBold)
        
        iconImageView.image = ImageManager.image(item.icon)
        iconImageView.tintColor  = item.type.iconColor.color
    }
    
    // دالة التأثير البصري
    func animateSelection() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }

    
}
