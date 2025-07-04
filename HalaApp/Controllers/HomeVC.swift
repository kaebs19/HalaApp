//
//  HomeVC.swift
//  HalaApp
//
//  Created by Mohammed Saleh on 29/06/2025.
//

import UIKit

class HomeVC: UIViewController {
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        setupUI()
        }
}


extension HomeVC {
    
    private func setupUI() {
        setNavigationButtons(items: [.notificationIcon] , title: .home)
    }
}
