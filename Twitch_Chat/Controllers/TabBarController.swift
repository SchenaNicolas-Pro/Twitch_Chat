//
//  TabBarController.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 06/01/2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        fontForTabBar()
        tabBar.backgroundColor = .black
        tabBar.tintColor = .white
        tabBar.barTintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
    }
    
    private func fontForTabBar() {
        let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)
    }
}
