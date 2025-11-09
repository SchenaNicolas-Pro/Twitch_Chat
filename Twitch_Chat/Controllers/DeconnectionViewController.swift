//
//  DeconnectionViewController.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 06/01/2025.
//

import UIKit

final class DeconnectionViewController: UIViewController {
    private let deconnectionView = DeconnectionView()
    var signOutButton: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = deconnectionView
        
        deconnectionView.signOutButton.addTarget(self, action: #selector(signOutButtonTapIn), for: .touchUpInside)
    }
    
    @objc
    func signOutButtonTapIn() {
        signOutButton?()
    }
}
