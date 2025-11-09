//
//  DeconnectionView.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 06/01/2025.
//

import UIKit

final class DeconnectionView: UIView {
    let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Déconnexion", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 8
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        addSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            signOutButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            signOutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            signOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            signOutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
